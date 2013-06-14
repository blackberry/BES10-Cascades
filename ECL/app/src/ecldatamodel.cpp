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
 * This is EclDataModel class, responsible for population of the data model
 * which in turn used by the UI to display the data.
 ****************************************************************************/

#include "ecldatamodel.hpp"
#include "eclconfig.hpp"

EclDataModel::EclDataModel(QObject *parent) :
        bb::cascades::DataModel(parent) {
    this->load("data/data.json");
}

/****************************************************************************
 * This function loads the json file into Variant list
 ****************************************************************************/
void EclDataModel::load(const QString& filename) {

    bb::data::JsonDataAccess jda;
    m_jsonList = jda.load(filename).value<QVariantList>();

    if (jda.hasError()) {
        bb::data::DataAccessError error = jda.error();
        qDebug() << filename << "JSON LOADING ERROR: " << error.errorType()
                << " : " << error.errorMessage();
    }

    emit itemsChanged ();
}

/****************************************************************************
 * This function returns the child count of the passed indexpath node in json
 * data
 ****************************************************************************/
int EclDataModel::childCount(const QVariantList& indexPath) {

    const int level = indexPath.size();

    int children = 0;

    if (level == 0) {
        children = m_jsonList.count();
    } else if (level == 1) {
        QString key = "";
        QVariantList list;

        const int header = indexPath[0].toInt();
        QVariantMap map = m_jsonList[header].value<QVariantMap>();
        QMapIterator<QString, QVariant> it(map);
        while (it.hasNext()) {
            it.next();
            key = it.key();
            if (key == EclConfig::jsonFieldName(EclConfig::JSonList)) {
                list = it.value().value<QVariantList>();
                children = list.count();
            }
        }
    }
    return children;
}

bool EclDataModel::hasChildren(const QVariantList& indexPath) {
    return childCount(indexPath) > 0;
}

/***************************************************************
 * Return data as a string QVariant for any requested indexPath.
 ***************************************************************/
QVariant EclDataModel::data(const QVariantList& indexPath) {
    QString key = "";
    QString value = "";
    QVariantMap map;

    if (1 == indexPath.size()) { // Header requested
        map = m_jsonList[indexPath[0].toInt()].value<QVariantMap>();
    } else if (2 == indexPath.size()) { // 2nd-level item requested
        const int header = indexPath[0].toInt();
        const int childItem = indexPath[1].toInt();

        QVariantMap l1Map = m_jsonList[header].value<QVariantMap>();
        QMapIterator<QString, QVariant> it(l1Map);

        QVariantList list;
        while (it.hasNext()) {
            it.next();
            key = it.key();
            if (key == EclConfig::jsonFieldName(EclConfig::JSonList)) {
                list = it.value().value<QVariantList>();
                map = list[childItem].value<QVariantMap>();
            }
        }
    }

    return QVariant(map);
}

/*********************************************************************
 * Returns the item type (header or item) for any requested indexPath.
 *********************************************************************/
QString EclDataModel::itemType(const QVariantList& indexPath) {
    switch (indexPath.size()) {
    case 0:
        return QString();
    case 1:
        return QLatin1String("header");
    default:
        return QLatin1String("item");
    }
}
