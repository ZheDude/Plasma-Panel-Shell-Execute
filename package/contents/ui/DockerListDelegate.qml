import QtQuick
import QtQml

import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaComponents3.ItemDelegate {
    id: item

    Layout.fillWidth: true

    property string iconItem: iconItem.children

    highlighted: activeFocus

    onHoveredChanged: if (hovered) {
        if (ListView.view) {
            ListView.view.currentIndex = index;
        }
        forceActiveFocus();
    }

    contentItem: RowLayout {
        id: row

        spacing: Kirigami.Units.smallSpacing

        Item {
            id: iconItem

            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
            Layout.minimumWidth: Layout.preferredWidth
            Layout.maximumWidth: Layout.preferredWidth
            Layout.minimumHeight: Layout.preferredHeight
            Layout.maximumHeight: Layout.preferredHeight
        }

        ColumnLayout {
            id: column
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                id: label
                Layout.fillWidth: true
                text: item.text
                textFormat: Text.PlainText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }
        }
    }
}
