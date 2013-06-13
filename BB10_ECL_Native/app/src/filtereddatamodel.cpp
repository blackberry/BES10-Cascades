/****************************************************************************
 * Copyright 2012 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ****************************************************************************/
/*
 * This is FilteredDataModel class, provides collapse/expand feature for the
 * header item in a listview which dynamically populates the expanded items
 *
 ****************************************************************************/

#include "filtereddatamodel.hpp"

FilteredDataModel::FilteredDataModel(bb::cascades::DataModel *sourceModel,
        QObject *parent) :
        bb::cascades::DataModel(parent), m_sourceDataModel(sourceModel) {
    initialize(sourceModel);
}

void FilteredDataModel::initialize(bb::cascades::DataModel *sourceModel) {
    m_sourceDataModel = sourceModel;
    QVariantList indexPath;

    int rootLevelItems = m_sourceDataModel->childCount(indexPath);
    for (int i = 0; i < rootLevelItems; i++) {
        m_expansionStates.append(true);
    }
}

/****************************************************************************
 * Return true if we are filtering this indexPath.
 * Return false if we are using the underlying data as-is.
 ****************************************************************************/
bool FilteredDataModel::isFiltered(const QVariantList& indexPath) const {
    return (indexPath.size() == 1 &&
            !isHeaderExpanded(indexPath[0].toInt()));
}

/****************************************************************************
 * Return the number of children.
 * Defer to the underlying data model unless the header is filtered.
 * Note: assumes m_sourceDataModel is initialized
 ****************************************************************************/
int FilteredDataModel::childCount(const QVariantList& indexPath) {
    if (isFiltered(indexPath)) {
        // Unexpanded header
        return 0;
    }
    return m_sourceDataModel->childCount(indexPath); // pointer always initialized
}

/****************************************************************************
 * Return true if it has children.
 ****************************************************************************/
bool FilteredDataModel::hasChildren(const QVariantList& indexPath) {
    if (isFiltered(indexPath)) {
        // Unexpanded header
        return false;
    }

    return m_sourceDataModel->hasChildren(indexPath);
}

/****************************************************************************
 * Return the data.
 * The ListView will only call this for valid data, so just
 * forward the request to the underlying data model.
 ****************************************************************************/
QVariant FilteredDataModel::data(const QVariantList& indexPath) {
    if (indexPath.size() == 1) { // header item
        QVariantMap data;
        data["data"] = m_sourceDataModel->data(indexPath);
        data["expanded"] = m_expansionStates.at(indexPath[0].toInt());

        return data;
    } else {
        // Pass through the data from the source model
        return m_sourceDataModel->data(indexPath);
    }
}

/****************************************************************************
 * Return the item type.
 * The ListView will only call this for valid data, so just
 * forward the request to the underlying data model.
 ****************************************************************************/

QString FilteredDataModel::itemType(const QVariantList& indexPath) {
    return m_sourceDataModel->itemType(indexPath);
}

/****************************************************************************
 * Expand or collapse the specified header.
 ****************************************************************************/

void FilteredDataModel::changeHeaderExpansion(int headerIndex) {
    m_expansionStates[headerIndex] = !m_expansionStates[headerIndex];
    emit itemsChanged(bb::cascades::DataModelChangeType::AddRemove);
}

bool FilteredDataModel::isHeaderExpanded(int headerIndex) const {
    return m_expansionStates[headerIndex];
}

void FilteredDataModel::reload(bb::cascades::DataModel *sourceModel) {
    initialize(sourceModel);
    emit itemsChanged(bb::cascades::DataModelChangeType::AddRemove);
}

