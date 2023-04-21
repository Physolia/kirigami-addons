// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtTest 1.2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kirigamiaddons.labs.components 1.0

Item {
    id: root

    AlbumMaximizeComponent {
        id: testAlbum

        parent: undefined
        width: 100
        height: 100

        property list<AlbumModelItem> items: [
            AlbumModelItem {
                type: AlbumModelItem.Image
                source: "https://kde.org/stuff/clipart/logo/kde-logo-white-blue-rounded-source.svg"
                tempSource: "https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"
                caption: "A test image"
            },
            AlbumModelItem {
                type: AlbumModelItem.Video
                source: "https://cdn.kde.org/promo/Announcements/Plasma/5.27/discover_hl_720p.webm"
                tempSource: "https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"
                caption: "A test video"
            },
            // This is just to test a blank caption.
            AlbumModelItem {
                type: AlbumModelItem.Image
                source: "https://kde.org/stuff/clipart/logo/kde-logo-white-blue-rounded-source.svg"
                tempSource: "https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"
                caption: ""
            }
        ]
        initialIndex: 0
        model: items

        TestCase {
            name: "AlbumQmlQObjectModelTest"
            when: windowShown

            function test_hasItems() {
                compare(testAlbum.content.count == 3, true);
            }

            // Select the image item and check that the current delegate has the correct properties.
            function test_imageParams() {
                testAlbum.content.currentIndex = 0;
                compare(testAlbum.content.currentItem.type, AlbumModelItem.Image)
                compare(
                    testAlbum.content.currentItem.source,
                    "https://kde.org/stuff/clipart/logo/kde-logo-white-blue-rounded-source.svg"
                )
                compare(
                    testAlbum.content.currentItem.tempSource,
                    "https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"
                )
                compare(
                    testAlbum.content.currentItem.caption,
                    "A test image"
                )
            }

            // Select the video item and check that the current delegate has the correct properties.
            function test_videoParams() {
                testAlbum.content.currentIndex = 1;
                compare(testAlbum.content.currentItem.type, AlbumModelItem.Video)
                compare(
                    testAlbum.content.currentItem.source,
                    "https://cdn.kde.org/promo/Announcements/Plasma/5.27/discover_hl_720p.webm"
                )
                compare(
                    testAlbum.content.currentItem.tempSource,
                    "https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"
                )
                compare(
                    testAlbum.content.currentItem.caption,
                    "A test video"
                )
            }

            // Select the image item and check that the image only actions are visible.
            function test_imageActions() {
                testAlbum.content.currentIndex = 0;
                compare(testAlbum.actions[2].visible, true)
                compare(testAlbum.actions[3].visible, true)
            }

            // Select the video item and check that the image only actions are not visible.
            function test_videoActions() {
                testAlbum.content.currentIndex = 1;
                compare(testAlbum.actions[2].visible, false)
                compare(testAlbum.actions[3].visible, false)
            }

            // Test that the caption is only visible if showCaption is true and a
            // captions string exists.
            function test_captionVisibility() {
                testAlbum.open()

                // Check that caption will be visible for the first item with
                // showCaption = true.
                testAlbum.showCaption = true
                testAlbum.content.currentIndex = 0;
                compare(testAlbum.footer.visible, true)

                // Check that caption will be visible for the second item with
                // showCaption = true.
                testAlbum.content.currentIndex = 1;
                compare(testAlbum.footer.visible, true)

                // Check that caption will not be visible for the third item with
                // showCaption = true.
                testAlbum.content.currentIndex = 2;
                compare(testAlbum.footer.visible, false)

                // Check that caption will not be visible for the first item with
                // showCaption = false.
                testAlbum.showCaption = false
                testAlbum.content.currentIndex = 0;
                compare(testAlbum.footer.visible, false)

                // Check that caption will not be visible for the second item with
                // showCaption = false.
                testAlbum.content.currentIndex = 1;
                compare(testAlbum.footer.visible, false)

                // Check that caption will not be visible for the third item with
                // showCaption = false.
                testAlbum.content.currentIndex = 2;
                compare(testAlbum.footer.visible, false)
            }
        }
    }
}
