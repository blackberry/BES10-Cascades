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

#ifndef ECLLISTITEM_HPP_
#define ECLLISTITEM_HPP_

namespace bb { namespace cascades { class StandardListItem; }}
namespace bb { namespace cascades { class Container; }}
namespace bb { namespace cascades { class ImageView; }}

#include <bb/cascades/CustomControl>
#include <bb/cascades/ListItemListener>

class EclListItem: public bb::cascades::CustomControl, public bb::cascades::ListItemListener {

    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle);
    Q_PROPERTY(QString description READ description WRITE setDescription);

public:
    EclListItem(bb::cascades::Container *parent = 0);
    void select(bool select);
    void reset(bool selected, bool activated);
    void activate(bool activate);

    const QString title();
    void setTitle(const QString newTitle);

    const QString description();
    void setDescription(const QString newDescription);

private:
    bb::cascades::ImageView *m_itemImage;
    bb::cascades::StandardListItem *m_listItem;
    bb::cascades::Container *m_highlightContainer;
    QString m_title;
};

#endif /* ECLLISTITEM_HPP_ */

