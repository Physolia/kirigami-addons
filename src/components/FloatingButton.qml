// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami

/**
 * This component is a button that can be displayed at the bottom of a page.
 *
 * @code{.qml}
 * import QtQuick 2.15
 * import QtQuick.Controls 2.15 as QQC2
 * import org.kde.kirigami 2.20 as Kirigami
 * import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents
 *
 * Kirigami.ScrollablePage {
 *     ListView {
 *         model: []
 *         delegate: QQC2.ItemDelegate {}
 *
 *         KirigamiComponents.FloatingButton {
 *             anchors {
 *                 right: parent.right
 *                 bottom: parent.bottom
 *                 margins: Kirigami.Units.largeSpacing
 *             }
 *
 *             action: Kirigami.Action {
 *                 text: "Add new item"
 *                 icon.name: "list-add"
 *             }
 *         }
 *     }
 * }
 * @endcode
 *
 * @since Kirigami Addons 0.11
 */
T.Button {
    id: controlRoot

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    height: Math.round(Kirigami.Units.gridUnit * 2.5)
    width: height

    readonly property size __effectiveIconSize: Qt.size(
        icon.height > 0 ? icon.height : Kirigami.Units.iconSizes.medium,
        icon.width > 0 ? icon.width : Kirigami.Units.iconSizes.medium,
    )

    // Text is not supported anyway
    spacing: 0

    hoverEnabled: !Kirigami.Settings.hasTransientTouchInput

    contentItem: Item {
        implicitWidth: controlRoot.__effectiveIconSize.width
        implicitHeight: controlRoot.__effectiveIconSize.height

        Kirigami.Icon {
            anchors.centerIn: parent
            width: controlRoot.__effectiveIconSize.width
            height: controlRoot.__effectiveIconSize.height
            color: controlRoot.icon.color
            source: controlRoot.icon.name !== "" ? controlRoot.icon.name : controlRoot.icon.source
        }
    }

    background: Kirigami.ShadowedRectangle {
        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.Window

        color: if (parent.down || parent.visualFocus) {
            Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
        } else if (parent.hovered) {
            Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.8)
        } else {
            Kirigami.Theme.backgroundColor
        }

        radius: Kirigami.Units.largeSpacing
        border {
            width: 1
            color: if (parent.down || parent.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
            } else if (parent.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2)
            }
        }

        shadow {
            size: 10
            xOffset: 2
            yOffset: 2
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }
    }
}
