import QtQuick 2.11
import QtQuick.Controls 1.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import "controls"
import Beam.Wallet 1.0
import QtQuick.Layouts 1.3

Item
{
    id: root

    anchors.fill: parent
    property bool isLockedMode: false

    StartViewModel { id: viewModel }    
    
    LogoComponent {
        id: logoComponent
    }

    StackView {
        id: startWizzardView
        anchors.fill: parent
        focus: true
        onCurrentItemChanged: {
            if (currentItem && currentItem.defaultFocusItem) {
                startWizzardView.currentItem.defaultFocusItem.forceActiveFocus();
            }
        }

        Component {
            id: start
            Rectangle
            {
                color: Style.background_main

                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: "qrc:/assets/bg.svg"
                }

                property Item defaultFocusItem: createNewWallet

                ConfirmationDialog {
                    id: restoreWalletConfirmation

                    okButtonText: qsTr("restore wallet")
                    okButtonIconSource: "qrc:/assets/icon-restore-blue.svg"
                    cancelVisible: true
                    cancelButtonIconSource: "qrc:/assets/icon-cancel-white.svg"
                    width: 460
                    height: 208

                    contentItem: Column {
                        anchors.fill: parent
                        anchors.margins: 30
                        spacing: 20

                        SFText {
                            horizontalAlignment : Text.AlignHCenter
                            width: parent.width
                            text: qsTr("Your funds will be fully restored from the blockchain. The transaction history and your addresses are stored locally and are encrypted with your password, hence it can't be restored.")
                            color: Style.content_main
                            font.pixelSize: 14
                            wrapMode: Text.Wrap
                        }

                        SFText {
                            horizontalAlignment : Text.AlignHCenter
                            width: parent.width
                            text: qsTr("That's the final version till the future validation and process.")
                            color: Style.content_main
                            font.pixelSize: 14
                            wrapMode: Text.Wrap
                        }
                    }
                    onAccepted: {
                        onClicked: {
                            viewModel.isRecoveryMode = true;
                            startWizzardView.push(restoreWallet);
                        }
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumHeight: 100
                        Layout.maximumHeight: 280
                    }

                    Loader { 
                        sourceComponent: logoComponent 
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillHeight: true
                        Layout.minimumHeight: 200//187
                        Layout.maximumHeight: 269
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 122
                        Layout.maximumHeight: 237
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        
                        spacing: 30

                        PrimaryButton {
                            id: createNewWallet
                            anchors.verticalCenter: parent.verticalCenter

                            text: qsTr("create new wallet")
                            icon.source: "qrc:/assets/icon-add-blue.svg"
                            onClicked: 
                            {
                                viewModel.isRecoveryMode = false;
                                startWizzardView.push(createWalletEntry);
                            }
                        }

                        CustomButton {
                            text: qsTr("restore wallet")
                            icon.source: "qrc:/assets/icon-restore.svg"
                            onClicked: {
                                restoreWalletConfirmation.open();
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                    }
                }
            }
        }

        Component {
            id: migrate
            Rectangle
            {
                color: Style.background_main

                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: "qrc:/assets/bg.svg"
                }

                property Item defaultFocusItem: startMigration

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumHeight: 100
                        Layout.maximumHeight: 280
                    }

                    Loader { 
                        sourceComponent: logoComponent 
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillHeight: true
                        Layout.minimumHeight: 200
                        Layout.maximumHeight: 269
                    }

                    Item {
                        Layout.preferredHeight: 30
                    }

                    SFText {
                        Layout.alignment: Qt.AlignHCenter
                
                        text: qsTr("Your wallet will be migrated to v.") + viewModel.walletVersion()
                        color: Style.content_main
                        font.pixelSize: 14
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 30
                        Layout.maximumHeight: 67
                    }

                    PrimaryButton {
                        id: startMigration
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.minimumHeight: 38

                        text: qsTr("start migration")
                        icon.source: "qrc:/assets/icon-repeat.svg"
                        onClicked: 
                        {
                            startWizzardView.push(selectWalletDBView);
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 30
                        Layout.maximumHeight: 65
                    }

                    SFText {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Login to another wallet or create new one")
                        color: Style.active
                        font.pixelSize: 14
                
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                startWizzardView.push(start);
                            }
                            hoverEnabled: true
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 30
                    }
                }
            }
        }

        Component {
            id: selectWalletDBView
            Rectangle
            {
                color: Style.background_main
                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 50

                    SFText {
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Qt.AlignHCenter
                        text: qsTr("Select the wallet database file")
                        color: Style.content_main
                        font.pixelSize: 36
                    }

                    CustomTableView {
                        id: tableView
                        property int rowHeight: 44
                        property int minWidth: 600
                        property int textLeftMargin: 20
                        Layout.alignment: Qt.AlignHCenter 
                        Layout.topMargin: 50
                        Layout.bottomMargin: 9
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: headerHeight + 3*rowHeight
                        Layout.maximumHeight: headerHeight + 5*rowHeight
                        Layout.minimumWidth: minWidth
                        Layout.maximumWidth: minWidth

                        frameVisible: false
                        selectionMode: SelectionMode.SingleSelection
                        backgroundVisible: false
                        model: viewModel.walletDBpaths

                        headerDelegate: Rectangle {
                            height: tableView.headerHeight
                            color: Style.background_second

                            SFLabel {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: tableView.textLeftMargin
                                horizontalAlignment: Qt.AlignHCenter
                                font.pixelSize: tableView.headerTextFontSize
                                color: Style.content_secondary
                                font.weight: Font.Normal
                                text: styleData.value
                            }
                        }

                        TableViewColumn {
                            role: "fullPath"
                            title: qsTr("Name")
                            width: 300
                            movable: false
                            delegate: Item {
                                width: parent.width
                                height: tableView.rowHeight
                                clip:true

                                SFLabel {
                                    font.pixelSize: 14
                                    anchors.left: parent.left
                                    anchors.leftMargin: tableView.textLeftMargin
                                    anchors.right: parent.right
                                    elide: Text.ElideLeft
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: styleData.value
                                    color: Style.content_main
                                    copyMenuEnabled: true
                                    onCopyText: viewModel.copyToClipboard(text)
                                }
                            }
                        }

                        TableViewColumn {
                            role: "fileSize"
                            title: qsTr("Size")
                            width: 120
                            movable: false
                            delegate: Item {
                                width: parent.width
                                height: tableView.rowHeight
                                clip:true

                                SFLabel {
                                    font.pixelSize: 14
                                    anchors.left: parent.left
                                    anchors.leftMargin: tableView.textLeftMargin
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Math.round(styleData.value / 1024) + qsTr(" kb")
                                    color: Style.content_main
                                }
                            }
                        }

                        TableViewColumn {
                            role: "lastWriteDateString"
                            title: qsTr("Date modified")
                            width: 150 
                            movable: false
                        }

                        rowDelegate: Item {
                            height: tableView.rowHeight
                            anchors.left: parent.left
                            anchors.right: parent.right

                            Rectangle {
                                anchors.fill: parent
                                color: styleData.selected ? Style.row_selected : Style.background_row_even
                                visible: styleData.alternate || styleData.selected
                            }
                        }

                        itemDelegate: TableItem {
                            elide: Text.ElideRight
                            clip:true

                            SFLabel {
                                font.pixelSize: 14
                                anchors.left: parent.left
                                anchors.leftMargin: tableView.textLeftMargin
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: styleData.value
                                color: Style.content_main
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 64
                    }

                    Row {
                        id: buttons
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 30

                        CustomButton {
                            text: qsTr("select file manually");
                            icon.source: "qrc:/assets/icon-folder.svg"
                            onClicked: {
                                // open fileOpenDialog
                                var path = viewModel.selectCustomWalletDB();

                                if (path.length > 0) {
                                    buttons.migrateWalletDB(path);
                                }
                            }
                        }

                        PrimaryButton {
                            id: nextButton
                            text: qsTr("next")
                            icon.source: "qrc:/assets/icon-next-blue.svg"
                            enabled: tableView.currentRow >= 0
                            onClicked: {
                                buttons.migrateWalletDB(viewModel.walletDBpaths[tableView.currentRow].fullPath);
                            }
                        }

                        function backAction() {
                            // remove wallet.db file
                            viewModel.deleteCurrentWalletDB();
                            startWizzardView.pop();
                        }

                        function migrateWalletDB(path) {
                            // copy wallet.db                         
                            viewModel.migrateWalletDB(path);
                            viewModel.isRecoveryMode = false;
                            startWizzardView.push(open, {"firstButtonVisible": true, "firstButtonText": qsTr("back"), 
                                                         "firstButtonIcon": "qrc:/assets/icon-back.svg", "firstButtonAction": backAction});
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 30
                        Layout.maximumHeight: 65
                    }

                    SFText {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Login to another wallet or create new one")
                        color: Style.active
                        font.pixelSize: 14
                
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                startWizzardView.push(start);
                            }
                            hoverEnabled: true
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 60
                        Layout.maximumHeight: 90
                    }
                }
            }
        }

        Component {
            id: createWalletEntry
            Rectangle
            {
                color: Style.background_main
                property Item defaultFocusItem: generateRecoveryPhraseButton

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    anchors.topMargin: 50
                    Column {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Create new wallet")
                            color: Style.content_main
                            font.pixelSize: 36
                        }
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Create new wallet with generating seed phrase.
        If you ever lose your device, you will need this phrase to recover your wallet!")
                            color: Style.content_main
                            wrapMode: Text.WordWrap
                            font.pixelSize: 14
                        }
                    }

                    Row {
                        topPadding: 100
                        spacing: 65
                        Layout.alignment: Qt.AlignHCenter
                        Layout.minimumHeight : 300
                        Layout.maximumHeight: 500
                        SecurityNote{
                            iconSource: "qrc:/assets/eye.svg"
                            text: qsTr("Do not let anyone see your seed phrase");
                        }
                        SecurityNote{
                            iconSource: "qrc:/assets/password.svg"
                            text: qsTr("Never type your seed phrase into password managers or elsewhere");
                        }
                        SecurityNote{
                            iconSource: "qrc:/assets/copy-two-paper-sheets-interface-symbol.svg"
                            text: qsTr("Keep the copies of your seed phrase in a safe place");
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 30

                        CustomButton {
                            text: qsTr("back");
                            icon.source: "qrc:/assets/icon-back.svg"
                            onClicked: startWizzardView.pop();
                        }

                        PrimaryButton {
                            id: generateRecoveryPhraseButton

                            text: qsTr("generate seed phrase")
                            icon.source: "qrc:/assets/icon-recovery.svg"
                            onClicked: startWizzardView.push(generateRecoveryPhrase);
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                        Layout.maximumHeight: 143
                    }
                }
            }
        }

        Component {
            id: generateRecoveryPhrase
            Rectangle {
                color: Style.background_main
                property Item defaultFocusItem: nextButton

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    anchors.topMargin: 50
                    Column {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 730
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Create new wallet")
                            color: Style.content_main
                            font.pixelSize: 36
                        }
                        SFText {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Your seed phrase is the access key to all the cryptocurrencies in your wallet. Write down the phrase to keep it in a safe or in a locked vault. Without the phrase you will not be able to recover your money.")
                            color: Style.content_main
                            wrapMode: Text.WordWrap
                            font.pixelSize: 14
                        }
                    }
                    ConfirmationDialog {
                        id: confirRecoveryPhrasesDialog
                        okButtonText: qsTr("I understand")
                        okButtonIconSource: "qrc:/assets/icon-done.svg"
                        cancelVisible: false
                        width: 460
                        text: qsTr("It is strictly recommended to write down the seed phrase on a paper. Storing it in a file makes it prone to cyber attacks and, therefore, less secure.")
                        onAccepted: {
                            onClicked: startWizzardView.push(checkRecoveryPhrase);
                        }
                    }
                    Grid{
                        id: phrasesView
                        Layout.alignment: Qt.AlignHCenter

                        topPadding: 50
                        columnSpacing: 30
                        rowSpacing:  20

                        Repeater {
                            model:viewModel.recoveryPhrases
                            Rectangle{
                                border.color: Style.background_second
                                color: "transparent"
                                width: 160
                                height: 38
                                radius: 30
                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 9
                                    anchors.left: parent.left
                                    color: Style.background_second
                                    width: 20
                                    height: 20
                                    radius: 10
                                    SFText {
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.index + 1
                                        font.pixelSize: 10
                                        color: Style.content_main
                                        opacity: 0.5
                                    }
                                }
                                SFText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.phrase
                                    font.pixelSize: 14
                                    color: Style.content_main
                                }
                            }
                        }
                    }
                    
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 50
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter

                        spacing: 30

                        CustomButton {
                            text: qsTr("back");
                            icon.source: "qrc:/assets/icon-back.svg"
                            onClicked: {
                                startWizzardView.pop();
                                viewModel.resetPhrases();
                            }
                        }

                        PrimaryButton {
                            id: nextButton
                            text: qsTr("next")
                            icon.source: "qrc:/assets/icon-next-blue.svg"
                            onClicked: {confirRecoveryPhrasesDialog.open();}
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                        Layout.maximumHeight: 143
                    }
                }
            }
        }

        Component {
            id: checkRecoveryPhrase
            Rectangle {
                color: Style.background_main
                property Item defaultFocusItem: null

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    anchors.topMargin: 50
                    Column {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 730
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Create new wallet")
                            color: Style.content_main
                            font.pixelSize: 36
                        }
                        SFText {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("To ensure the seed phrase is written down, please fill-in the specific words below")
                            color: Style.content_main
                            wrapMode: Text.WordWrap
                            font.pixelSize: 14
                        }
                    }
 
                    Grid{
                        Layout.alignment: Qt.AlignHCenter

                        topPadding: 50
                        columnSpacing: 30
                        rowSpacing:  20

                        Repeater {
                            model:viewModel.checkPhrases

                            Row {
                                width: 160
                                height: 38
                                spacing: 20
                                Item {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 9
                                    width: 20
                                    height: 20
                                    Rectangle {
                                        color: "transparent"
                                        border.color: Style.content_secondary
                                        width: 20
                                        height: 20
                                        radius: 10
                                        SFText {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.index + 1
                                            font.pixelSize: 10
                                            color: Style.content_secondary
                                        }
                                        visible: modelData.value.length == 0
                                    }

                                    Rectangle {
                                        id: correctPhraseRect
                                        color: modelData.isCorrect ? Style.active : Style.validator_error
                                        width: 20
                                        height: 20
                                        radius: 10
                                        SFText {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.index + 1
                                            font.pixelSize: 10
                                            color: Style.background_main
                                        }
                                        visible: modelData.value.length > 0
                                    }

                                    DropShadow {
                                        anchors.fill: correctPhraseRect
                                        radius: 5
                                        samples: 9
                                        color: modelData.isCorrect ? Style.active : Style.validator_error
                                        source: correctPhraseRect
                                        visible: correctPhraseRect.visible
                                    }
                                }

                                SFTextInput {
                                    id: phraseValue
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 6
                                    width: 121
                                    font.pixelSize: 14
                                    color: (modelData.isCorrect || modelData.value.length == 0) ? Style.content_main : Style.validator_error
                                    backgroundColor: (modelData.isCorrect || modelData.value.length == 0) ? Style.content_main : Style.validator_error
                                    text: modelData.value
                                    Component.onCompleted: {
                                        modelData.value = "";
                                        if (defaultFocusItem == null) {
                                            defaultFocusItem = phraseValue;
                                        }
                                    }
                                }
                                Binding {
                                    target: modelData
                                    property: "value"
                                    value: phraseValue.text
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 120
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter

                        spacing: 30

                        CustomButton {
                            text: qsTr("back");
                            icon.source: "qrc:/assets/icon-back.svg"
                            onClicked: {
                                startWizzardView.pop();
                                viewModel.resetPhrases();
                            }
                        }

                        PrimaryButton {
                            id: checkRecoveryNextButton
                            text: qsTr("next")
                            enabled: {
                                var enable = true;
                                for(var i = 0; i < viewModel.checkPhrases.length; ++i)
                                {
                                    enable &= viewModel.checkPhrases[i].isCorrect;
                                }
                                return enable;
                            }
                            icon.source: "qrc:/assets/icon-next-blue.svg"
                            onClicked: startWizzardView.push(create);
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                        Layout.maximumHeight: 143
                    }
                }
            }
        }

        Component {
            id: restoreWallet
            Rectangle {
                color: Style.background_main
                property Item defaultFocusItem: null

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    anchors.topMargin: 50
                    Column {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 730
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Restore wallet")
                            color: Style.content_main
                            font.pixelSize: 36
                        }
                        SFText {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Type in or paste your seed phrase")
                            color: Style.content_main
                            wrapMode: Text.WordWrap
                            font.pixelSize: 14
                        }
                    }
 
                    Grid{
                        Layout.alignment: Qt.AlignHCenter

                        topPadding: 50
                        columnSpacing: 30
                        rowSpacing:  20

                        Repeater {
                            model:viewModel.recoveryPhrases

                            Row {
                                width: 160
                                height: 38
                                spacing: 20
                                Item {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 9
                                    width: 20
                                    height: 20
                                    Rectangle {
                                        color: "transparent"
                                        border.color: Style.background_second
                                        width: 20
                                        height: 20
                                        radius: 10
                                        SFText {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.index + 1
                                            font.pixelSize: 10
                                            color: Style.background_second
                                        }
                                        visible: modelData.value.length == 0
                                    }

                                    Rectangle {
                                        id: correctPhraseRect
                                        color: modelData.isAllowed ? Style.background_second : Style.validator_error
                                        width: 20
                                        height: 20
                                        radius: 10
                                        SFText {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.index + 1
                                            font.pixelSize: 10
                                            color: Style.content_main
                                            opacity: 0.5
                                        }
                                        visible: modelData.value.length > 0
                                    }
                                }

                                SFTextInput {
                                    id: phraseValue
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 6
                                    width: 121
                                    font.pixelSize: 14
                                    color: (modelData.isAllowed || modelData.value.length == 0) ? Style.content_main : Style.validator_error
                                    backgroundColor: (modelData.isAllowed || modelData.value.length == 0) ? Style.content_main : Style.validator_error
                                    text: modelData.value
                                    onTextEdited: {
                                        var phrases = text.split(viewModel.phrasesSeparator);
                                        if (phrases.length > viewModel.recoveryPhrases.length) {
                                            for(var i = 0; i < viewModel.recoveryPhrases.length; ++i)
                                            {
                                                viewModel.recoveryPhrases[i].value = phrases[i];
                                            }
                                        }
                                    }
                                    Component.onCompleted: {
                                        if (modelData.index == 0) {
                                            defaultFocusItem = phraseValue;
                                        }
                                    }
                                }
                                Binding {
                                    target: modelData
                                    property: "value"
                                    value: phraseValue.text
                                }
                            }
                        }
                    }
                    
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 50
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter

                        spacing: 30

                        CustomButton {
                            text: qsTr("back");
                            icon.source: "qrc:/assets/icon-back.svg"
                            onClicked: {
                                startWizzardView.pop();
                                viewModel.resetPhrases();
                            }
                        }

                        PrimaryButton {
                            id: checkRecoveryNextButton
                            text: qsTr("next")
                            enabled: {
                                var enable = true;
                                for(var i = 0; i < viewModel.recoveryPhrases.length; ++i)
                                {
                                    enable &= viewModel.recoveryPhrases[i].isAllowed;
                                }
                                return enable;
                            }
                            icon.source: "qrc:/assets/icon-next-blue.svg"
                            onClicked: startWizzardView.push(create);
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                        Layout.maximumHeight: 143
                    }
                }
            }
        }

        Component {
            id: create
            Rectangle
            {
                color: Style.background_main

                property Item defaultFocusItem: password

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    anchors.topMargin: 50
                    Column {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 730
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Create new wallet")
                            color: Style.content_main
                            font.pixelSize: 36
                        }
                        SFText {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Create password to access your wallet")
                            color: Style.content_main
                            wrapMode: Text.WordWrap
                            font.pixelSize: 14
                        }
                    }
                    
                    Column {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 400
                        Layout.topMargin: 50
                        spacing: 30

                        Column {
                            width: parent.width

                            spacing: 10

                            SFText {
                                text: qsTr("Enter password")
                                color: Style.content_main
                                font.pixelSize: 14
                                font.styleName: "Bold"; font.weight: Font.Bold
                            }

                            SFTextInput {

                                id:password

                                width: parent.width

                                font.pixelSize: 14
                                color: Style.content_main
                                echoMode: TextInput.Password
                                onTextChanged: if (password.text.length > 0) passwordError.text = ""
                            }

                            RowLayout{
                                id: strengthChecker

                                property var strengthTests: 
                                [
                                    {exp: new RegExp("(?=.{1,})")                                                               , color: Style.validator_error, msg: "Very weak password"},
                                    {exp: new RegExp("((?=.{6,})(?=.*[0-9]))|((?=.{6,})(?=.*[A-Z]))|((?=.{6,})(?=.*[a-z]))")    , color: Style.validator_error, msg: "Weak password"},
                                    {exp: new RegExp("((?=.{6,})(?=.*[A-Z])(?=.*[a-z]))|((?=.{6,})(?=.*[0-9])(?=.*[a-z]))")     , color: Style.validator_warning, msg: "Medium strength password"},
                                    {exp: new RegExp("(?=.{8,})(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])")                              , color: Style.validator_warning, msg: "Medium strength password"},
                                    {exp: new RegExp("(?=.{10,})(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])")                             , color: Style.active, msg: "Strong password"},
                                    {exp: new RegExp("(?=.{10,})(?=.*[!@#\$%\^&\*])(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])")          , color: Style.active, msg: "Very strong password"},
                                ]

                                function passwordStrength(pass)
                                {
                                    for(var i = strengthTests.length - 1; i >= 0; i--)
                                        if(strengthTests[i].exp.test(pass))
                                            return i + 1;
                               
                                    return 0;
                                }

                                property var strength: passwordStrength(password.text)

                                width: parent.width

                                spacing: 8

                                Repeater{
                                    model: parent.strengthTests.length

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 4
                                        border.width: index < parent.strength ? 0 : 1
                                        border.color: Style.background_second
                                        radius: 10
                                        color: index < parent.strength ? parent.strengthTests[parent.strength-1].color : Style.background_main
                                    }
                                }
                            }

                            SFText {
                                text: strengthChecker.strength > 0 ? strengthChecker.strengthTests[strengthChecker.strength-1].msg : ""
                                color: Style.content_secondary
                                font.pixelSize: 14
                                height: 16
                                width: parent.width
                            }
                        }

                        Column {
                            width: parent.width
                            anchors.bottomMargin: 6
                            spacing: 10

                            SFText {
                                text: qsTr("Confirm password")
                                color: Style.content_main
                                font.pixelSize: 14
                                font.styleName: "Bold"; font.weight: Font.Bold
                            }

                            SFTextInput {
                                id: confirmPassword
                                width: parent.width

                                font.pixelSize: 14
                                color: Style.content_main
                                echoMode: TextInput.Password
                                onTextChanged: if (confirmPassword.text.length > 0) passwordError.text = ""
                            }

                            SFText {
                                id: passwordError
                                color: Style.validator_error
                                font.pixelSize: 14
                                height: 16
                                width: parent.width
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 50
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                    
                        spacing: 30

                        CustomButton {
                            text: qsTr("back");
                            icon.source: "qrc:/assets/icon-back.svg"
                            onClicked: startWizzardView.pop();
                        }
                        PrimaryButton {
                            text: qsTr("next")
                            icon.source : "qrc:/assets/icon-next-blue.svg"
                            onClicked: {
                                if(password.text.length == 0)
                                {
                                    passwordError.text = qsTr("Please, enter password");
                                }
                                else if(password.text != confirmPassword.text)
                                {
                                    passwordError.text = qsTr("Passwords do not match");
                                }
                                else
                                {
                                    viewModel.setPassword(password.text);
                                    startWizzardView.push(nodeSetup);
                                }
                            }
                        }
                    }
                     
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                        Layout.maximumHeight: 143
                    }
                }
            }
        }

        Component {
            id: nodeSetup

            Rectangle
            {   
                id: nodeSetupRectangle
                color: Style.background_main
                property Item defaultFocusItem: localNodeButton

                function onRestoreCancelled(useRandomNode) {
                    if (useRandomNode) {
                        nodeSetupRectangle.defaultFocusItem = randomNodeButton;
                        randomNodeButton.checked = true;
                    } else if (viewModel.getIsRunLocalNode()) {
                        nodeSetupRectangle.defaultFocusItem = localNodeButton;
                        localNodeButton.checked = true;

                        portInput.text = viewModel.localPort;
                        localNodePeer.text = viewModel.localNodePeer;
                    } else {
                        nodeSetupRectangle.defaultFocusItem = remoteNodeButton;
                        remoteNodeButton.checked = true;

                        remoteNodeAddrInput.text = viewModel.remoteNodeAddress;
                    }
                    nodeSetupRectangle.defaultFocusItem.focus = true;
                }

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    anchors.topMargin: 50
                    Column {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 730
                        SFText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: qsTr("Setup node connectivity")
                            color: Style.content_main
                            font.pixelSize: 36
                        }
                    }

                    Column {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.preferredWidth: 440
                        topPadding: 50

                        clip: true

                        spacing: 15
                        ButtonGroup {
                            id: nodePreferencesGroup
                        }

                        CustomRadioButton {
                            id: localNodeButton
                            text: qsTr("Run integrated node (recommended)")
                            ButtonGroup.group: nodePreferencesGroup
                            font.pixelSize: 14
                            checked: true
                        }
                        Column {
                            id: localNodePanel
                            visible: localNodeButton.checked
                            width: parent.width
                            leftPadding: 34

                            spacing: 10

                            SFText {
                                text: qsTr("Enter port to listen")
                                color: Style.content_main
                                font.pixelSize: 14
                                font.styleName: "Bold"; font.weight: Font.Bold
                            }

                            SFTextInput {
                                id:portInput
                                width: parent.width

                                font.pixelSize: 14
                                color: Style.content_main
                                text: viewModel.defaultPortToListen()
                                onTextChanged: if (portInput.text.length > 0) portError.text = ""
                            }
                            SFText {
                                id: portError
                                color: Style.validator_error
                                font.pixelSize: 14
                            }

                            RowLayout {
                                width: parent.width
                                spacing: 10

                                SFText {
                                    text: qsTr("Peer")
                                    color: Style.content_main
                                    font.pixelSize: 14
                                    font.styleName: "Bold"; font.weight: Font.Bold
                                }

                                SFTextInput {
                                    id: localNodePeer
                                    Layout.fillWidth: true
                                    activeFocusOnTab: true
                                    font.pixelSize: 12
                                    color: Style.content_main
                                    text: viewModel.chooseRandomNode()
                                    validator: RegExpValidator { regExp: /^(\s|\x180E)*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|([\w.-]+(?:\.[\w\.-]+)+))(:([0-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?(\s|\x180E)*$/ }
                                    onTextChanged: if (peerError.text.length > 0) peerError.text = ""
                                }
                            }
                            SFText {
                                id: peerError
                                color: Style.validator_error
                                font.pixelSize: 14
                            }
                        }

                        CustomRadioButton {
                            id: randomNodeButton
                            text: qsTr("Connect to random remote node")
                            ButtonGroup.group: nodePreferencesGroup
                            font.pixelSize: 14
                            enabled: viewModel.isRecoveryMode == false
                        }
                        Row {
                            width: parent.width
                            spacing: 10
                            CustomRadioButton {
                                id: remoteNodeButton
                                text: qsTr("Connect to specific remote node")
                                ButtonGroup.group: nodePreferencesGroup
                                font.pixelSize: 14
                                enabled: viewModel.isRecoveryMode == false
                            }
                            SFTextInput {
                                id:remoteNodeAddrInput
                                visible: remoteNodeButton.checked
                                width: parent.width - parent.spacing - remoteNodeButton.width
                                font.pixelSize: 14
                                color: Style.content_main
                                text: viewModel.defaultRemoteNodeAddr()
                                validator: RegExpValidator { regExp: /^(\s|\x180E)*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|([\w.-]+(?:\.[\w\.-]+)+))(:([0-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?(\s|\x180E)*$/ }
                                onTextChanged: if (remoteNodeAddrInput.text.length > 0) remoteNodeAddrError.text = ""
                                bottomPadding: 8 // TODO add default value of this item to controls
                            }
                        }
                        Column {
                            id: remoteNodePanel
                            visible: remoteNodeButton.checked
                            width: parent.width
                            leftPadding: 40

                            spacing: 10

                            SFText {
                                id: remoteNodeAddrError
                                color: Style.validator_error
                                font.pixelSize: 14
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 20
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 30

                        CustomButton {
                            text: qsTr("back");
                            icon.source: "qrc:/assets/icon-back.svg"
                            onClicked: startWizzardView.pop();
                        }

                        PrimaryButton {
                            text: viewModel.isRecoveryMode ? qsTr("restore wallet") : qsTr("start using your wallet");
                            icon.source: viewModel.isRecoveryMode ? "qrc:/assets/icon-restore-blue.svg" : "qrc:/assets/icon-next-blue.svg"
                            enabled: nodePreferencesGroup.checkState != Qt.Unchecked
                            onClicked:{
                                if (localNodeButton.checked) {
                                    if (portInput.text.trim().length === 0) {
                                        portError.text = qsTr("Please, specify port to listen ");
                                        return;
                                    }
                                    if (localNodePeer.text.trim().length === 0) {
                                        peerError.text = qsTr("Please, specify correct peer");
                                        return;
                                    }
                                    if (!localNodePeer.acceptableInput) {
                                        peerError.text = qsTr("Please, specify peer");
                                        return;
                                    }

                                    viewModel.setupLocalNode(parseInt(portInput.text), localNodePeer.text);
                                }
                                else if (remoteNodeButton.checked) {
                                    if (remoteNodeAddrInput.text.trim().length === 0) {
                                        remoteNodeAddrError.text = qsTr("Please, specify address of the remote node");
                                        return;
                                    }
                                    viewModel.setupRemoteNode(remoteNodeAddrInput.text.trim());
                                }
                                else if (randomNodeButton.checked) {
                                    viewModel.setupRandomNode();
                                }

                                if (viewModel.createWallet()) {
                                    startWizzardView.push("qrc:/loading.qml", {"isRecoveryMode" : viewModel.isRecoveryMode, "isCreating" : true, "cancelCallback": startWizzardView.pop});
                                }
                                else {
                                    // TODO(alex.starun): error message if wallet not created
                                }
                            }
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                        Layout.maximumHeight: 143
                    }
                }
            }
        }

        Component {
            id: open
            Rectangle
            {
                property Item defaultFocusItem: openPassword

                property bool firstButtonVisible: false
                property string firstButtonText: qsTr("login to another wallet")
                property var firstButtonIcon: "qrc:/assets/icon-change.svg"
                property var firstButtonAction: confirmChangeWalletDialog.open

                // default methods for open wallet, can be changed for unlock wallet
                property var openWallet: function (pass) {
                    return viewModel.openWallet(pass);
                }
                property var loadWallet: function () {
                    root.parent.setSource("qrc:/loading.qml", {"isRecoveryMode" : false, "isCreating" : false});
                }

                color: Style.background_main

                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: "qrc:/assets/bg.svg"
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumHeight: 70
                        Layout.maximumHeight: 280
                    }

                    Loader { 
                        sourceComponent: logoComponent 
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillHeight: true
                        Layout.minimumHeight: 200//187
                        Layout.maximumHeight: 269
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 30
                        Layout.maximumHeight: 89

                    }
                    Item {
                        Layout.preferredHeight: 186 
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumHeight: 67
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 70
                        Layout.maximumHeight: 280
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 200
                        Layout.maximumHeight: 269
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 30
                        Layout.maximumHeight: 89
                    }

                    SFText {
                        Layout.alignment: Qt.AlignHCenter
                
                        text: qsTr("Enter your password to access the current wallet")
                        color: Style.content_main
                        font.pixelSize: 14
                    }

                    Column {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 400
                        Layout.topMargin: 50
                        spacing: 2

                        SFText {
                            text: qsTr("Enter password")
                            color: Style.content_main
                            font.pixelSize: 14
                            font.styleName: "Bold"; font.weight: Font.Bold
                        }

                        SFTextInput {
                            id: openPassword
                            width: parent.width
                            focus: true
                            activeFocusOnTab: true
                            font.pixelSize: 14
                            color: Style.content_main
                            echoMode: TextInput.Password
                            onAccepted: btnCurrentWallet.clicked()
                            onTextChanged: if (openPassword.text.length > 0) openPasswordError.text = ""

                        }

                        SFText {
                            height: 16
                            width: parent.width
                            id: openPasswordError
                            color: Style.validator_error
                            font.pixelSize: 14
                        }
                    }

                    ConfirmationDialog {
                        id: confirmChangeWalletDialog
                        okButtonText: qsTr("change wallet")
                        okButtonIconSource: "qrc:/assets/icon-change-blue.svg"
                        cancelButtonIconSource: "qrc:/assets/icon-cancel-white.svg"
                        cancelVisible: true
                        width: 460
                        text: qsTr("If you login to another wallet, all unsaved transaction history for the current wallet will be lost.")
                        onAccepted: {
                            viewModel.isRecoveryMode = true;
                            startWizzardView.push(restoreWallet);
                        }
                    }

                    ConfirmationDialog {
                        id: confirmFogotPassDialog
                        okButtonText: qsTr("restore wallet")
                        okButtonIconSource: "qrc:/assets/icon-restore-blue.svg"
                        cancelButtonIconSource: "qrc:/assets/icon-cancel-white.svg"
                        cancelVisible: true
                        width: 460
                        text: qsTr("You can restore you wallet using your seed phrase but all transaction history will be lost.")
                        onAccepted: {
                            viewModel.isRecoveryMode = true;
                            startWizzardView.push(restoreWallet);
                        }
                    }
                    
                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 33
                        spacing: 19
                        
                        CustomButton {
                            visible: firstButtonVisible
                            text: firstButtonText
                            icon.source: firstButtonIcon
                            onClicked: firstButtonAction()
                        }

                        PrimaryButton {
                            anchors.verticalCenter: parent.verticalCenter
                            id: btnCurrentWallet
                            text: qsTr("show my wallet")
                            icon.source: "qrc:/assets/icon-wallet-small.svg"
                            onClicked: {
                                if(openPassword.text.length == 0)
                                {
                                    openPasswordError.text = qsTr("Please, enter password");
                                }
                                else
                                {
                                    if(!openWallet(openPassword.text))
                                    {
                                        openPasswordError.text = qsTr("Invalid password provided.");
                                    }
                                    else
                                    {
                                        loadWallet();
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 67
                    }
                }
            }
        }

        Component.onCompleted: {
            if (isLockedMode) {
                startWizzardView.push(open, { "openWallet": function (pass) { return viewModel.checkWalletPassword(pass); },
                                              "loadWallet": function () { root.parent.setSource("qrc:/main.qml"); } });
            }
            else if (viewModel.walletExists) {
                startWizzardView.push(open);
            }
            else if (viewModel.isFindExistingWalletDB())
            {
                startWizzardView.push(migrate);
            }
            else {
                startWizzardView.push(start);
            }
        }
    }
}

