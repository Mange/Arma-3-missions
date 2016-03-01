private _unit     = param [0, objNull, [objNull]];
private _icon     = param [1, "\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa", [""]];
private _color    = param [2, (side group _unit) call BIS_fnc_sideColor, [[]], 4];
private _position = param [3, getPosATLVisual _unit, [[]], 3];
private _text     = param [4, name _unit, [""]];
private _arrows   = param [5, true, [true]];

private _distance = player distance _x;

// Make the icon/text smaller the further away you are, but lengthen the factor
// by only looking at 20% of the distance so it doesn't shrink too fast.
private _scale = 1 / (_distance * 0.2);
if (_scale > 2) then { _scale = 2; };
if (_scale < 0.3) then { _scale = 0.3; };

// Make it a bit more transparent when near
// http://www.wolframalpha.com/input/?i=plot+f(x)%3D(ln(x)%2B2)%2F4,+0%3Cx%3C7
if (_distance < 7) then {
  private _opacity = ((ln _distance) + 2) / 4;
  _color set [3, (_opacity max 0.1) min 1.0];
};

drawIcon3D [
  _icon, _color, _position,
  1 * _scale, 1 * _scale, // Width, height
  0, // Angle
  _text, // Optional text
  0, // Optional shadow
  0.05 * _scale, // Optional text size
  "TahomaB", // Optional font
  "center", // Optional text alignment
  _arrows // Optional show side arrows?
];
