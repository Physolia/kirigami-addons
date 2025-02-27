/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

import "private" as Private

/**
 * @brief A Form delegate that corresponds to a checkbox.
 *
 * This component is used for individual settings that can be toggled on, off, or tristate, typically in conjunction with multiple other checkboxes.
 *
 * Use the inherited QtQuick.Controls.AbstractButton.text property to define the main text of the checkbox.
 *
 * If you need a purely on/off toggle for a single setting, consider using a FormSwitchDelegate.
 *
 * If you need multiple toggles for the same setting, use a FormRadioDelegate
 * instead.
 *
 * If you need multiple values for the same setting, use a
 * FormComboBoxDelegate instead.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @see QtQuick.Controls.AbstractButton
 * @see FormSwitchDelegate
 * @see FormComboBoxDelegate
 * @see FormRadioDelegate
 *
 * @inherit QtQuick.Controls.CheckDelegate
 */
T.CheckDelegate {
    id: root

    /**
     * @brief A label containing secondary text that appears under the
     * inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     */
    property string description: ""

    /**
     * @brief This property holds an item that will be displayed to the left
     * of the delegate's contents.
     */
    property var leading: null

    /**
     * @brief This property holds the padding after the leading item.
     */
    property real leadingPadding: Kirigami.Units.smallSpacing

    /**
     * @brief This property holds an item that will be displayed to the right
     * of the delegate's contents.
     */
    property var trailing: null

    /**
     * @brief This property holds the padding before the trailing item.
     */
    property real trailingPadding: Kirigami.Units.smallSpacing

    /**
     * @brief This property allows to override the internal description
     * item (a QtQuick.Controls.Label) with a custom component.
     */
    property alias descriptionItem: internalDescriptionItem

    leftPadding: Kirigami.Units.gridUnit
    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.gridUnit

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    Layout.fillWidth: true

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        Controls.CheckBox {
            id: checkBoxItem
            Layout.rightMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            focusPolicy: Qt.NoFocus // provided by delegate

            checkState: root.checkState
            nextCheckState: root.nextCheckState
            tristate: root.tristate

            onToggled: {
                root.toggle();
                root.toggled();
            }
            onClicked: root.clicked()
            onPressAndHold: root.pressAndHold()
            onDoubleClicked: root.doubleClicked()

            enabled: root.enabled
            checked: root.checked
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            Controls.Label {
                text: root.text
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
            }

            Controls.Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                visible: root.description !== ""
                wrapMode: Text.Wrap
            }
        }

        Private.ContentItemLoader {
            Layout.leftMargin: visible ? root.trailingPadding : 0
            visible: root.trailing
            implicitHeight: visible ? root.trailing.implicitHeight : 0
            implicitWidth: visible ? root.trailing.implicitWidth : 0
            contentItem: root.trailing
        }
    }
}

