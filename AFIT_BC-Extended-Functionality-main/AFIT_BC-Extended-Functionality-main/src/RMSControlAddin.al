controladdin RMSButton
{
    MinimumHeight = 20;
    MaximumHeight = 30;
    MaximumWidth = 180;
    MinimumWidth = 120;

    VerticalStretch = false;
    VerticalShrink = true;
    RequestedHeight = 30;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts = 'bscript.js';

    StyleSheets = 'BStyleSheet.css';
    StartupScript = 'BStart.js';
    event Ready();
    event ButtonPressed()
    procedure addButton(ButtonName: Text)

}