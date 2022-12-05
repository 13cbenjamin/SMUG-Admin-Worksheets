function customUpdate(id, tid, regexjs, regextype, WorksheetType, CaseID, MaximumNmbersAfterDecimalOnMath, TruncateValue) {

    try {
        var jHasMath = document.getElementById('HasMath').value
        var str = document.getElementById('JavaMathArray').value
        var jJavaMathArray = str.split("`");
        str = document.getElementById('JavaMathFormatArray').value
        var jJavaMathFormatArray = str.split("`");
    }
    //catch (err) {alert('An error occurred trying to perform the math ' + err.message)}

    catch (err) { }

    var vv = document.getElementById(id);
    if (vv != null) {

        if (vv.value.match(regexjs) == null && vv.value != '') {

            alert('Please enter a valid value in this field. The value must be of type - [' + regextype + ']')
            vv.style.backgroundColor = '#f00';
            vv.style.color = '#fff';
            vv.focus();
        }

        else {
            vv.style.backgroundColor = '#fff';
            vv.style.color = '#000';
            var nlen = 500
            var entered = vv.value
            var enteredlen = entered.length

            if (enteredlen < nlen) {
                entered = encodeURIComponent(entered);
                if (WCszBT == 'ie') { var objHTTP = new ActiveXObject("Microsoft.XMLHTTP"); } else { var objHTTP = new XMLHttpRequest(); }
                var szURL = 'xmlCustomWorksheetUpdate.aspx?cid=' + CaseID + '&tid=' + tid + '&id=' + id + '&val=' + escape(entered);
                objHTTP.open("POST", szURL, false);
                objHTTP.send('1');
            }
            else {
                var np = enteredlen / nlen
                for (i = 0; i < np; i++) {
                    if (WCszBT == 'ie') { var objHTTP = new ActiveXObject("Microsoft.XMLHTTP"); } else { var objHTTP = new XMLHttpRequest(); }
                    var szURL = 'xmlCustomWorksheetUpdate.aspx?i=' + i + '&wstype=' + WorksheetType + '&cid=' + CaseID + '&tid=' + tid + '&id=' + id + '&val=' + escape(encodeURIComponent(entered.substr(i * nlen, nlen)));
                    objHTTP.open("POST", szURL, false);
                    objHTTP.send('1');
                }

            }
        }
    }

    if (jHasMath != '') {

        var MathFormatArray = jJavaMathFormatArray;
        var JavaArray = jJavaMathArray;

        var span1
        var span2
        var span11
        var span22

        for (var k = 0; k < JavaArray.length; k++) {
            var str1 = JavaArray[k]
            var str2 = MathFormatArray[k]
            span1 = str1.indexOf("|")
            span2 = str1.substr(0, span1)
            str1 = str1.substr(span1 + 1)

            span11 = str2.indexOf("|")
            span22 = str2.substr(0, span11)
            str2 = str2.substr(span11 + 1)

            try {
                var d = eval(str1)
            }
            catch (err) { }

            var p = Math.pow(10, MaximumNmbersAfterDecimalOnMath)
            try {
                if (str2 == 'Money') {
                    if ((d * p) / p < 999999999) {
                        if (TruncateValue == 'True') {
                            document.getElementById('mathspan' + span2).innerText = '$' + (Math.trunc(d * p) / p).formatMoney(2, '.', ',');
                        }
                        else {
                            document.getElementById('mathspan' + span2).innerText = '$' + (Math.round(d * p) / p).formatMoney(2, '.', ',');
                        }
                    }
                    else {
                        document.getElementById('mathspan' + span2).innerText = '999999999'
                    }
                }
                else {
                    
                    if ((d * p) / p < 999999999) {
                        if (TruncateValue == 'True') {
                            document.getElementById('mathspan' + span2).innerText = Math.trunc(d * p) / p
                        }
                        else { 
                        document.getElementById('mathspan' + span2).innerText = Math.round(d * p) / p
                        }
                    }
                    else {
                        document.getElementById('mathspan' + span2).innerText = '999999999'
                    }
                }
            }
            catch (err) {

            }


        }
    }
}

Number.prototype.formatMoney = function (c, d, t) {
    var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

function update_checkbox(id, tid, WorksheetType, CaseID) {

    var vv = document.getElementById(id);
    if (vv != null) {
        if (WCszBT == 'ie') { var objHTTP = new ActiveXObject("Microsoft.XMLHTTP"); } else { var objHTTP = new XMLHttpRequest(); }
        var szURL = 'xmlCustomWorksheetUpdate.aspx?wstype=' + WorksheetType + '&cid=' + CaseID + '&tid=' + tid + '&id=' + id + '&val=' + escape(vv.checked);
        objHTTP.open("POST", szURL, false);
        objHTTP.send('1');
    }
}

function update_special(id, tid, WorksheetType, CaseID) {
    var vv = document.getElementById(id);
    if (vv != null) {
        if (WCszBT == 'ie') { var objHTTP = new ActiveXObject("Microsoft.XMLHTTP"); } else { var objHTTP = new XMLHttpRequest(); }
        var szURL = 'xmlCustomWorksheetUpdate.aspx?wstype=' + WorksheetType + '&cid=' + CaseID + '&tid=' + tid + '&id=' + id + '&val=' + escape(vv.value);
        objHTTP.open("POST", szURL, false);
        objHTTP.send('1');
    }
}


function select_gsListBox(gsListBoxData) {

    try {

        var str = document.getElementById('gsListBoxData').value
        var gsArray = str.split("~");

        //var gsArray = [gsListBoxData];
        for (var k = 0; k < gsArray.length; k++) {
            var str1 = gsArray[k]
            var str2

            span1 = str1.indexOf("|")
            span2 = str1.substr(0, span1)
            str1 = str1.substr(span1 + 1)
            setSelectedIndex(span2, document.getElementById('' + span2 + ''), str1)
        }
    }
    catch (err) { }
}

function setSelectedIndex(a, s, v) {
    try {
        for (var i = 0; i < s.options.length; i++) {
            if (s.options[i].text == v) {
                s.options[i].selected = true;
                return;
            }
        }
    }
    catch (err) { }
}

function getSelected(opt) {
    var selected = new Array();
    var index = 0;
    for (var intLoop = 0; intLoop < opt.length; intLoop++) {
        if ((opt[intLoop].selected) ||
               (opt[intLoop].checked)) {
                   index = selected.length;
                   selected[index] = new Object;
                   selected[index].value = opt[intLoop].value;
                   selected[index].index = intLoop;
               }
    }
    return selected;
}

function update_listbox(id, tid, WorksheetType, CaseID) {
    var vv = document.getElementById(id);
    var opt = vv.options

    var sel = getSelected(opt);
    var strSel = "";
    for (var item in sel)
        strSel += '`' + sel[item].value + '`';

    if (WCszBT == 'ie') { var objHTTP = new ActiveXObject("Microsoft.XMLHTTP"); } else { var objHTTP = new XMLHttpRequest(); }
    var szURL = 'xmlCustomWorksheetUpdate.aspx?wstype=' + WorksheetType + '&cid=' + CaseID + '&tid=' + tid + '&id=' + id + '&val=' + escape(strSel);
    objHTTP.open("POST", szURL, false);
    objHTTP.send('1');

}

function gotosection() {
    var dropdownIndex = document.getElementById('ddlSectionLink').selectedIndex;
    var dropdownValue = document.getElementById('ddlSectionLink')[dropdownIndex].value;

    if (dropdownIndex != 0) {
        WCgoToApp(dropdownValue);
    }

}

function snapselect(WorksheetType, CaseID, xWin) {

    WCgoToApp('SnapshotOptions.aspx?xWin=' + xWin + '&wstype=' + WorksheetType + '&s=' + CaseID);
}

function snapchange(WorksheetType, WindowSuffix, xWin) {

    var dropdownIndex = document.getElementById('ddlSnapshot').selectedIndex;
    var dropdownValue = document.getElementById('ddlSnapshot')[dropdownIndex].value;
    var exp1 = 'PleaseWaitStatic.aspx?prog=CaseWorksheetSnapshot.aspx?qs=progskip=~|xWin=' + xWin + '|wstype=' + WorksheetType + '|a=' + dropdownValue
    if (dropdownValue != 0) {
        WCopenWindow(exp1, 'CaseWorksheet' + WindowSuffix, ',scrollbars,resizable,status=1', 'Case'); return false;
    }
    else {
        var exp1 = 'CaseWorksheet.aspx?xWin=' + xWin + '&wstype=' + WorksheetType
        WCgoToApp(exp1, 0)
    }
}

function worksheetchange(xWin) {

    var dropdownIndex = document.getElementById('ddlWorksheet').selectedIndex;
    var dropdownValue = document.getElementById('ddlWorksheet')[dropdownIndex].value;
    var exp1 = 'CaseWorksheet.aspx?xWin=' + xWin + '&wstype=' + dropdownValue + '&cc=qq'
    if (dropdownValue != 0) {
            WCgoToApp(exp1, 0)
        }
    }    
