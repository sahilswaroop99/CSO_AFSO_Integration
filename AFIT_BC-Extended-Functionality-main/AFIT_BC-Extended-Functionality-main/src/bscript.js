function addButton(buttonName) {

    var placeholder = document.getElementById('controlAddIn');

    var button = document.createElement('button');

    button.textContent = buttonName;

    button.onclick = function () {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ButtonPressed');
    }
    placeholder.appendChild(button);

}