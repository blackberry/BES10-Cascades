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
 * This is EclListItem class, responsible for creation of custom list item
 * control.
 ****************************************************************************/

#include "ecllistitem.hpp"
#include <bb/cascades/StandardListItem>
#include <bb/cascades/Container>
#include <bb/cascades/DockLayout>
#include <bb/cascades/ImageView>
#include <bb/cascades/Color>
#include <bb/cascades/Label>
#include "eclutils.hpp"

using namespace bb::cascades;

EclListItem::EclListItem(Container *parent) :
        CustomControl(parent), m_itemImage(0), m_listItem(0), m_highlightContainer(0) {

    Container *itemContainer = new Container();
    DockLayout *itemLayout = new DockLayout();
    itemContainer->setLayout(itemLayout);

    m_listItem = new StandardListItem();
    Container *imageContainer = new Container();
    imageContainer->setRightPadding(20);
    imageContainer->setHorizontalAlignment(HorizontalAlignment::Right);
    imageContainer->setVerticalAlignment(VerticalAlignment::Center);

    m_itemImage = new ImageView();
    m_itemImage->setImageSource(QUrl("asset:///images/forward.png"));
    imageContainer->add(m_itemImage);

    itemContainer->add(m_listItem);
    itemContainer->add(imageContainer);

    // A Colored Container will be used to show if an item is highlighted.
    m_highlightContainer = new Container();

    m_highlightContainer->setBackground(Color::fromARGB(0xff75b5d3));
    m_highlightContainer->setOpacity(0.0);
    m_highlightContainer->setPreferredWidth(m_highlightContainer->maxWidth());

    m_highlightContainer->setPreferredHeight(120.0f);

    itemContainer->add(m_highlightContainer);
    setRoot(itemContainer);

}

/***************************************************************
 * Highlights the selected item.
 ***************************************************************/
void EclListItem::select(bool select) {

	// When an item is selected show the colored highlight Container
    if (select) {
        m_highlightContainer->setOpacity(0.5f);
    } else {
        m_highlightContainer->setOpacity(0.0f);
    }

}

void EclListItem::reset(bool selected, bool activated) {
    Q_UNUSED(activated);
    select(selected);
}

void EclListItem::activate(bool activate) {
    select(activate);
}

/***************************************************************
 * Return the list item's title.
 ***************************************************************/
const QString EclListItem::title() {
    return m_title;
}

/***************************************************************
 * Sets the title for the list item.
 ***************************************************************/
void EclListItem::setTitle(const QString newTitle) {
    m_title = newTitle;
    if (m_listItem) {
        m_listItem->setTitle(m_title);
    }
}

/***************************************************************
 * Return the list item's description.
 ***************************************************************/
const QString EclListItem::description() {
    return m_listItem->description();
}
/***************************************************************
 * Sets the description for the list item.
 ***************************************************************/
void EclListItem::setDescription(const QString newDescription) {
    if (m_listItem) {
        m_listItem->setDescription(newDescription);
    }
}
