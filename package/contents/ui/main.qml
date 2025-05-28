import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents

PlasmoidItem{
  id: root
  toolTipTextFormat: Text.StyledText
  toolTipSubText: i18n("Select a script to run")

  compactRepresentation: MouseArea {
    id: compactRoot
    readonly property bool tooSmall: Plasmoid.formFactor === PlasmaCore.Types.Horizontal && Math.round(2 * (compactRoot.height / 5)) <= Kirigami.Theme.smallFont.pixelSize

    Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
    Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
    Layout.preferredWidth: isVertical ? -1 : Layout.minimumWidth

    Layout.minimumHeight: isVertical ? label.height : Kirigami.Theme.smallFont.pixelSize
    Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
    Layout.preferredHeight: isVertical ? Layout.minimumHeight : Kirigami.Units.iconSizes.sizeForLabels * 2

    property bool wasExpanded
    onPressed: wasExpanded = root.expanded
    onClicked: root.expanded = !wasExpanded

    Row {
        id: compactRow

        anchors.centerIn: parent
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            id: terminalIcon
            source: "terminal"
            anchors.verticalCenter: parent.verticalCenter
            height: compactRoot.height - Math.round(Kirigami.Units.smallSpacing / 2)
            width: height
            visible: root.showIcon
        }

        PlasmaComponents.Label {
            id: label
            width: root.isVertical ? compactRoot.width : contentWidth
            height: root.isVertical ? contentHeight : compactRoot.height
            text: root.displayedName
            textFormat: Text.PlainText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            fontSizeMode: root.isVertical ? Text.HorizontalFit : Text.VerticalFit
            font.pixelSize: tooSmall ? Kirigami.Theme.defaultFont.pixelSize : Kirigami.Units.iconSizes.roundedIconSize(Kirigami.Units.gridUnit * 2)
            minimumPointSize: Kirigami.Theme.smallFont.pointSize
            visible: root.showName
        }
    }
  }
}
