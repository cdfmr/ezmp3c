//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    EZShapeForm.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Shape Form Control
//
// 2006-05-06
// - Initial release with comments
//------------------------------------------------------------------------------

unit EZShapeForm;

interface

uses
  Windows, Messages, Types, Classes, SysUtils, Graphics, Controls, Forms,
  EZImageButton;

type

////////////////////////////////////////////////////////////////////////////////
// TEZShapeForm Interface

  TEZShapeForm = class(TCustomControl)
  private
    { Private declarations }
    FCanMinimize: Boolean;
    FMinimizeButton, FCloseButton: TEZImageButton;
    FTitleFont: TFont;
    FForm: TCustomForm;

    procedure SetCanMinimize(Value: Boolean);
    procedure SetTitleFont(Value: TFont);
    procedure TitleFontChanged(Sender: TObject);

    procedure MakeShapeForm;
    procedure AdjustButtons;
    procedure MinimizeButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    { Protected declarations }
    procedure SetParent(Value:TWinControl); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property CanMinimize: Boolean read FCanMinimize write SetCanMinimize
      default False;
    property TitleFont: TFont read FTitleFont write SetTitleFont;

    property Caption;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('EZCtrls', [TEZShapeForm]);
end;

{ TEZShapeForm }

{$R *.RES}

const
  EParentError = 'TEZShapeForm must be placed on a form.';

////////////////////////////////////////////////////////////////////////////////
// Constructor / Destructor

constructor TEZShapeForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  Align := alClient;

  FTitleFont := TFont.Create;
  FTitleFont.Name := 'Tahoma';
  FTitleFont.Style := [fsBold];
  FTitleFont.Size := 10;
  FTitleFont.Color := clWhite;
  FTitleFont.OnChange := TitleFontChanged;

  FCloseButton := TEZImageButton.Create(Self);
  FCloseButton.Top := 6;
  FCloseButton.Glyph.LoadFromResourceName(HInstance, 'EZFORM_CLOSE_BUTTON');
  FCloseButton.Visible := True;
  FCloseButton.Parent := Self;
  FCloseButton.OnClick := CloseButtonClick;

  FMinimizeButton := nil;
end;

destructor TEZShapeForm.Destroy;
begin
  if FMinimizeButton <> nil then
    FMinimizeButton.Free;
  FCloseButton.Free;
  FTitleFont.Free;
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// Routines to create a shape form

//------------------------------------------------------------------------------
// Procedure: TEZShapeForm.MakeShapeForm
// Arguments: None
// Result:    None
// Comment:   Set the window region to create a shape form
//------------------------------------------------------------------------------

procedure TEZShapeForm.MakeShapeForm;
var
  WindowRgn: HRGN;
  UnVisibleRgn: HRGN;
  Points: array[0..4] of TPoint;
begin
  // Whole rectangle
  WindowRgn := CreateRectRgn(0, 0, Width, Height);

  // Cut off left top corner
  Points[0] := Point(0, 0);
  Points[1] := Point(0, 10);
  Points[2] := Point(8, 2);
  Points[3] := Point(16, 2);
  Points[4] := Point(18, 0);
  UnVisibleRgn := CreatePolygonRgn(Points, 5, ALTERNATE);
  CombineRgn(WindowRgn, WindowRgn, UnVisibleRgn, RGN_DIFF);
  DeleteObject(UnVisibleRgn);

  // Cut off right top corner
  Points[0] := Point(Width, 0);
  Points[1] := Point(Width, 10);
  Points[2] := Point(Width - 8, 2);
  if FCanMinimize then
  begin
    Points[3] := Point(Width - 18 - 46 - 33 + 3, 2);
    Points[4] := Point(Width - 18 - 46 - 33 + 1, 0);
  end
  else
  begin
    Points[3] := Point(Width - 18 - 23 - 33 + 3, 2);
    Points[4] := Point(Width - 18 - 23 - 33 + 1, 0);
  end;
  UnVisibleRgn := CreatePolygonRgn(Points, 5, ALTERNATE);
  CombineRgn(WindowRgn, WindowRgn, UnVisibleRgn, RGN_DIFF);
  DeleteObject(UnVisibleRgn);

  // Cut off left bottom corner
  Points[0] := Point(0, Height);
  Points[1] := Point(0, Height - 4);
  Points[2] := Point(4, Height);
  UnVisibleRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
  CombineRgn(WindowRgn, WindowRgn, UnVisibleRgn, RGN_DIFF);
  DeleteObject(UnVisibleRgn);

  // Cut off right bottom corner
  Points[0] := Point(Width, Height);
  Points[1] := Point(Width, Height - 4);
  Points[2] := Point(Width - 4, Height);
  UnVisibleRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
  CombineRgn(WindowRgn, WindowRgn, UnVisibleRgn, RGN_DIFF);
  DeleteObject(UnVisibleRgn);

  // Set window region
  SetWindowRgn(FForm.Handle, WindowRgn, True);
end;

procedure TEZShapeForm.AdjustButtons;
begin
  FCloseButton.Left := Width - 18 - 23 + 3;
  if FMinimizeButton <> nil then
    FMinimizeButton.Left := FCloseButton.Left -23;
end;

////////////////////////////////////////////////////////////////////////////////
// Events

procedure TEZShapeForm.MinimizeButtonClick(Sender: TObject);
begin
  SendMessage(FForm.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TEZShapeForm.CloseButtonClick(Sender: TObject);
begin
  FForm.Close;
end;

procedure TEZShapeForm.FormShow(Sender: TObject);
begin
  if not (csDesigning in ComponentState) then
    MakeShapeForm;
end;

////////////////////////////////////////////////////////////////////////////////
// Messages

procedure TEZShapeForm.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TEZShapeForm.Loaded;
begin
  inherited Loaded;
  AdjustButtons;
end;

procedure TEZShapeForm.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

  // Allow move the form with the fake "title bar"
  if Y <= 21 then
  begin
    ReleaseCapture();
    SendMessage(FForm.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TEZShapeForm.Resize;
begin
  inherited Resize;
  Invalidate;
  AdjustButtons;
  if not (csDesigning in ComponentState) then
    MakeShapeForm;
end;

//------------------------------------------------------------------------------
// Procedure: TEZShapeForm.Paint
// Arguments: None
// Result:    None
// Comment:   Paint the form
//------------------------------------------------------------------------------

procedure TEZShapeForm.Paint;
var
  Bitmap: TBitmap;
  X, Y: Integer;
  R: TRect;
begin
  // Draw background
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(BoundsRect);

  // Draw left top corner
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_LEFT_TOP');
    X := 0;
    Y := 0;
    Canvas.Draw(X, Y, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw right top corner
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_RIGHT_TOP');
    X := Width - Bitmap.Width;
    Y := 0;
    Canvas.Draw(X, Y, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw left bottom corner
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_LEFT_BOTTOM');
    X := 0;
    Y := Height - Bitmap.Height;
    Canvas.Draw(X, Y, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw right bottom corner
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_RIGHT_BOTTOM');
    X := Width - Bitmap.Width;
    Y := Height - Bitmap.Height;
    Canvas.Draw(X, Y, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw left side
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_LEFT');
    R := Rect(0, 23, Bitmap.Width, Height - 6);
    Canvas.StretchDraw(R, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw right side
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_RIGHT');
    R := Rect(Width - Bitmap.Width, 23, Width, Height - 6);
    Canvas.StretchDraw(R, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw bottom side
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_BOTTOM');
    R := Rect(37, Height - 6, Width - 6, Height);
    Canvas.StretchDraw(R, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw right part of the title bar
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_TITLE_RIGHT');
    if FCanMinimize then
      R := Rect(Width - 46 - 18, 0, Width - 18, Bitmap.Height)
    else
      R := Rect(Width - 23 - 18, 0, Width - 18, Bitmap.Height);
    Canvas.StretchDraw(R, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw center part of the title bar
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_TITLE_CENTER');
    if FCanMinimize then
      R := Rect(Width - 33 - 46 - 18, 0, Width - 46 - 18, Bitmap.Height)
    else
      R := Rect(Width - 33 - 23 - 18, 0, Width - 23 - 18, Bitmap.Height);
    Canvas.StretchDraw(R, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw left part of the title bar
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromResourceName(HInstance, 'EZFORM_TITLE_LEFT');
    if FCanMinimize then
      R := Rect(19, 0, Width - 33 - 46 - 18, Bitmap.Height)
    else
      R := Rect(19, 0, Width - 33 - 23 - 18, Bitmap.Height);
    Canvas.StretchDraw(R, Bitmap);
  finally
    Bitmap.Free;
  end;

  // Draw caption
  Canvas.Font.Assign(FTitleFont);
  Canvas.Brush.Style := bsClear;
  X := 22;
  Y := (22 - Canvas.TextHeight(Caption)) div 2;
  Canvas.TextOut(X, Y, Caption);
end;

////////////////////////////////////////////////////////////////////////////////
// Properties

procedure TEZShapeForm.SetCanMinimize(Value: Boolean);
begin
  if FCanMinimize <> Value then
  begin
    FCanMinimize := Value;
    Invalidate;

    // Create or free minimize button
    if FCanMinimize then
    begin
      FMinimizeButton := TEZImageButton.Create(Self);
      FMinimizeButton.Top := 6;
      FMinimizeButton.Glyph.LoadFromResourceName(HInstance, 'EZFORM_MINIMIZE_BUTTON');
      FMinimizeButton.Visible := True;
      FMinimizeButton.Parent := Self;
      FMinimizeButton.OnClick := MinimizeButtonClick;
    end
    else
      FreeAndNil(FMinimizeButton);

    AdjustButtons;
    if not (csDesigning in ComponentState) then
      MakeShapeForm;
  end;
end;

procedure TEZShapeForm.SetParent(Value: TWinControl);
begin
  inherited SetParent(Value);

  if Value <> nil then
    if not (Value is TCustomForm) then // Only allow to place on a form
      raise Exception.Create(EParentError)
    else
    begin
      FForm := TCustomForm(Parent);
      if FForm is TForm then
        TForm(FForm).OnShow := FormShow;
      if not (csDesigning in ComponentState) then
        FForm.BorderStyle := bsNone;
    end;
end;

procedure TEZShapeForm.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TEZShapeForm.TitleFontChanged(Sender: TObject);
begin
  Invalidate;
end;

end.
