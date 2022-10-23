/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * A single card that is contained in a form.
 * 
 * The height will take the implicit height of the contentItem, while the width 
 * is expected to be given by the parent.
 */
Item {
    id: root
    
    /**
     * The contents of the form card.
     */
    property Item contentItem: Item {}
    
    /**
     * The maximum width of the card.
     */
    property real maximumWidth: Kirigami.Units.gridUnit * 30
    
    property real padding: 0
    property real verticalPadding: padding
    property real horizontalPadding: padding
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    property real leftPadding: horizontalPadding
    property real rightPadding: horizontalPadding
    
    /**
     * Whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth
    
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false
    
    implicitHeight: topPadding + bottomPadding + contentItem.implicitHeight + rectangle.borderWidth * 2
    
    onContentItemChanged: {
        // clear old items
        contentItemLoader.children = "";
        
        contentItem.parent = contentItemLoader;
        contentItem.anchors.fill = contentItemLoader;
        contentItemLoader.children.push(contentItem);
    }
    
    Rectangle {
        id: rectangle
        readonly property real borderWidth: 1
        
        border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)
        border.width: borderWidth
        
        // only have card radius if it isn't filling the entire width
        radius: root.cardWidthRestricted ? Kirigami.Units.smallSpacing : 0
        color: Kirigami.Theme.backgroundColor
        
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        
        anchors.leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
        anchors.rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
        
        Item {
            id: contentItemLoader
            anchors.fill: parent
            
            // add 1 to margins to account for the border (so content doesn't overlap it)
            anchors.leftMargin: root.leftPadding + rectangle.borderWidth
            anchors.rightMargin: root.rightPadding + rectangle.borderWidth
            anchors.topMargin: root.topPadding + rectangle.borderWidth
            anchors.bottomMargin: root.bottomPadding + rectangle.borderWidth
        }
    }
}
