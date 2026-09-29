import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import org.kde.iconthemes as KIconThemes
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: generalConfigPage

    property alias cfg_icon: icon.text
    property string cfg_iconDefault

    property string cfg_scriptsCommand
    property string cfg_scriptsCommandDefault


    Kirigami.FormLayout {
        id: form

        Layout.fillWidth: true

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Select an Icon"
        }

        RowLayout {
            Kirigami.FormData.label: "Icon:"

            QQC2.TextField {
                id: icon
                implicitWidth: 300
            }

            QQC2.Button {
                icon.name: "folder"
                onClicked: {
                    iconDialog.open();
                }
            }
        }

        KIconThemes.IconDialog {
            id: iconDialog

            onIconNameChanged: iconName => {
                generalConfigPage.cfg_icon = iconName;
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Scripts"
        }

        property var commandList: []

        Component.onCompleted: {
            try {
                commandList = JSON.parse(cfg_scriptsCommand);
                console.log(commandList);
            } catch (e) {
                commandList = [];
            }
        }

        function saveList() {
            cfg_scriptsCommand = JSON.stringify(commandList);
        }

        GridLayout {
            width: parent.width
            Layout.fillWidth: true

            QQC2.Label {
                text: "Manual Entries:"
            }

            QQC2.Button {
                text: "Add Entry"
                icon.name: "list-add"
                onClicked: {
                    form.commandList.push({
                        label: "New",
                        iconName: "google-drive",
                        commandString: ""
                    });
                    form.commandList = form.commandList.slice();
                    form.saveList();
                }
            }
        }
        ColumnLayout {
            Repeater {
                model: form.commandList
                delegate: RowLayout {
                    required property var modelData
                    required property int index
                    QQC2.TextField {
                        text: form.modelData.label
                        placeholderText: "Label"
                        onEditingFinished: {
                            form.commandList[index].label = text;
                            form.saveList();
                        }
                    }
                    QQC2.TextField {
                        text: modelData.commandString
                        placeholderText: "Command"
                        onEditingFinished: {
                            form.commandList[index].commandString = text;
                            form.saveList();
                        }
                    }
                    QQC2.ToolButton {
                        icon.name: "list-remove"
                        onClicked: {
                            form.commandList.splice(index, 1);
                            form.commandList = form.commandList.slice();
                            form.saveList();
                        }
                    }
                }
            }
        }
    }
}