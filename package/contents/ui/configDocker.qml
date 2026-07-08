pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_dockerMode: modeCombo.currentValue
    property string cfg_dockerContainers: "[]"

    property var containerList: []

    Component.onCompleted: {
        try {
            containerList = JSON.parse(cfg_dockerContainers);
        } catch (e) {
            containerList = [];
        }
    }

    function saveList() {
        cfg_dockerContainers = JSON.stringify(containerList);
    }

    QQC2.ComboBox {
        id: modeCombo
        Kirigami.FormData.label: "Container source:"
        model: ["dynamic", "manual"]
        // currentValue binding needs Qt 6.4+ ; otherwise use currentIndex + textRole mapping
    }

    ColumnLayout {
        Kirigami.FormData.label: "Manual containers:"
        visible: modeCombo.currentValue === "manual"

        Repeater {
            model: page.containerList
            delegate: RowLayout {
                required property var modelData
                required property int index
                QQC2.TextField {
                    text: modelData.label
                    placeholderText: "Label"
                    onEditingFinished: {
                        page.containerList[index].label = text;
                        page.saveList();
                    }
                }
                QQC2.TextField {
                    text: modelData.containerName
                    placeholderText: "Docker container name"
                    onEditingFinished: {
                        page.containerList[index].containerName = text;
                        page.saveList();
                    }
                }
                QQC2.ToolButton {
                    icon.name: "list-remove"
                    onClicked: {
                        page.containerList.splice(index, 1);
                        page.containerList = page.containerList.slice();
                        page.saveList();
                    }
                }
            }
        }

        QQC2.Button {
            text: "Add container"
            icon.name: "list-add"
            onClicked: {
                page.containerList.push({
                    label: "New",
                    iconName: "docker-desktop",
                    containerName: ""
                });
                page.containerList = page.containerList.slice();
                page.saveList();
            }
        }
    }
}
