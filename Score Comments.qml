import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import MuseScore 3.0

MuseScore {
    menuPath: "Plugins.Score Comments"
    description: "Dockable panel to store multi-line internal annotations in the score's metadata."
    version: "1.0"
    thumbnailName: "Score Comments.png"
    pluginType: "dock"
    requiresScore: true

    property string currentScoreId: ""

    // Triggered when the dock is initially opened
    onRun: {
        if (curScore) {
            textArea.text = curScore.metaTag("comments");
            currentScoreId = curScore.scoreName;
        }
    }

    // Timer to detect if the user switches score tabs while the dock is open.
    // This keeps the text area synced with the currently viewed score.
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (curScore) {
                if (curScore.scoreName !== currentScoreId) {
                    currentScoreId = curScore.scoreName;
                    textArea.text = curScore.metaTag("comments");
                }
            } else {
                currentScoreId = "";
                textArea.text = "";
            }
        }
    }

    Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label {
                text: "Score Comments"
                font.bold: true
                font.pointSize: 10
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: textArea
                    wrapMode: TextArea.Wrap
                    placeholderText: "Type score comments here...\n\nThese comments are saved to the project metadata and will not be visible on the printed score."
                    
                    // Restart the save timer whenever the user types something
                    onTextEdited: {
                        debounceSaveTimer.restart();
                    }
                }
            }
        }
    }

    // Debounce timer: Saves the data and marks the score as modified 
    // 600ms after the user stops typing.
    Timer {
        id: debounceSaveTimer
        interval: 600
        repeat: false
        onTriggered: {
            if (curScore && curScore.metaTag("comments") !== textArea.text) {
                curScore.startCmd();
                curScore.setMetaTag("comments", textArea.text);
                curScore.endCmd();
            }
        }
    }
}