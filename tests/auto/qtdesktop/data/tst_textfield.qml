/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtTest 1.0

TestCase {
    id: testCase
    name: "Tests_TextField"
    when: windowShown
    width: 400
    height: 400

    function test_text() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')

        compare(textfield.text, "")
        textfield.text = "hello world"
        compare(textfield.text, "hello world")
    }

    function test_maximumLength() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')

        textfield.text = "hello world"
        textfield.maximumLength = 5
        compare(textfield.text, "hello")
    }

    function test_length() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')

        textfield.text = "hello world"
        compare(textfield.length, 11)
    }


    function test_readonly() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        compare(textfield.readOnly, false)
        textfield.text = "hello"
        textfield.readOnly = true
        keyPress(Qt.Key_9)
        compare(textfield.text,"hello")
    }

    function test_inputMask() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        // +/- not required, 1 digit required, 1 aphabetic character required and 2 digits not required
        textfield.inputMask = "#9A00"

        keyPress(Qt.Key_Minus)
        compare(textfield.text,"-")
        compare(textfield.acceptableInput, false)

        keyPress(Qt.Key_9)
        compare(textfield.text,"-9")
        compare(textfield.acceptableInput, false)

        keyPress(Qt.Key_B)
        compare(textfield.text,"-9b")
        compare(textfield.acceptableInput, true)

        keyPress(Qt.Key_1)
        compare(textfield.text,"-9b1")
        compare(textfield.acceptableInput, true)

        keyPress(Qt.Key_1)
        compare(textfield.text,"-9b11")
        compare(textfield.acceptableInput, true)

        keyPress(Qt.Key_Backspace)
        keyPress(Qt.Key_Backspace)
        keyPress(Qt.Key_Backspace)
        compare(textfield.text,"-9")
        compare(textfield.acceptableInput, false)

        keyPress(Qt.Key_3)
        compare(textfield.acceptableInput, false)
        compare(textfield.text,"-93")
    }

    function test_validator() {
        var textfield = Qt.createQmlObject('import QtQuick 2.0; import QtDesktop 1.0; TextField {validator: RegExpValidator { regExp: /(red|blue|green)?/; }}', testCase, '')

        textfield.text = "blu"
        compare(textfield.acceptableInput, false)

        textfield.text = "blue"
        compare(textfield.acceptableInput, true)

        textfield.text = "bluee"
        compare(textfield.acceptableInput, false)
    }

    function test_selectAll() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.selectAll();

        keyPress(Qt.Key_Delete)
        compare(textfield.text, "")
    }

    function test_select() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.select(5, 8);

        compare(textfield.selectionEnd, 8)
        compare(textfield.selectionStart, 5)
        compare(textfield.selectedText, "is ")
        keyPress(Qt.Key_Delete)
        compare(textfield.text, "this my text")
    }

    function test_cursorPosition() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        compare(textfield.cursorPosition, 0)
        keyPress(Qt.Key_M)
        compare(textfield.cursorPosition, 1)
        keyPress(Qt.Key_Y)
        compare(textfield.cursorPosition, 2)

        textfield.cursorPosition = 1
        keyPress(Qt.Key_A)
        compare(textfield.text, "may")
    }

    function test_selectWord() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.selectWord();
        compare(textfield.selectedText, "text")
        textfield.cursorPosition = 2
        textfield.selectWord();
        compare(textfield.selectedText, "this")
    }

    function copy() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.text = "this is my text"
        textfield.select(0, 5)
        textfield.copy()
    }

    function test_getText() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        var gettext = textfield.getText(0, 4)
        compare(gettext, "this")
    }

    function test_insert() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.insert(8, "not ")
        compare(textfield.text, "this is not my text")
    }

    function test_deselect() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.selectWord();
        textfield.deselect()
        compare(textfield.selectedText, "")
    }

    function test_undo() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.insert(8, "not ")
        compare(textfield.canUndo, true)
        textfield.undo()
        compare(textfield.text, "this is my text")
    }

    function test_redo() {
        var textfield = Qt.createQmlObject('import QtDesktop 1.0; TextField {}', testCase, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.insert(8, "not ")
        textfield.undo()
        compare(textfield.canRedo, true)
        textfield.redo()
        compare(textfield.text, "this is not my text")
    }
}