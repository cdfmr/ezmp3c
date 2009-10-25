//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    EZImageButton.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Image Button Control
//
// 2006-04-24
// - Initial release with comments
//------------------------------------------------------------------------------

unit EZImageButton;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, ExtCtrls;

type

  TParentControl = class(TWinControl);

////////////////////////////////////////////////////////////////////////////////
// TEZImageButton Interface

  TEZImageButton = class(TGraphicControl)
  private
    { Private declarations }
    FGlyph: TBitmap;
    FGlyphNumber: Integer;
    FTransparent: Boolean;

    procedure DrawNormalFrame(ACanvas: TCanvas);
    procedure DrawGlyph(ACanvas: TCanvas);

    procedure SetGlyph(Value: TBitmap);
    procedure SetGlyphNumber(Value: Integer);
    procedure SetTransparent(Value: Boolean);
    procedure GlyphChanged(Sender: TObject);

    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    { Protected declarations }
    IsMouseOn, IsMouseDown: Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Anchors;
    property Caption;
    property Enabled;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ParentFont;
    property ShowHint;
    property Visible;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property GlyphNumber: Integer read FGlyphNumber write SetGlyphNumber;
    property Transparent: Boolean read FTransparent write SetTransparent;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('EZCtrls', [TEZImageButton]);
end;

////////////////////////////////////////////////////////////////////////////////
// Routines from RxLib

const
  PaletteMask = $02000000;

function PaletteColor(Color: TColor): Longint;
begin
  Result := ColorToRGB(Color) or PaletteMask;
end;

procedure StretchBltTransparent(DstDC: HDC; DstX, DstY, DstW, DstH: Integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, SrcH: Integer; Palette: HPalette;
  TransparentColor: TColorRef);
var
  Color: TColorRef;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBitmap;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBitmap;
  MemDC, BackDC, ObjectDC, SaveDC: HDC;
  palDst, palMem, palSave, palObj: HPalette;
begin
  { Create some DCs to hold temporary data }
  BackDC := CreateCompatibleDC(DstDC);
  ObjectDC := CreateCompatibleDC(DstDC);
  MemDC := CreateCompatibleDC(DstDC);
  SaveDC := CreateCompatibleDC(DstDC);
  { Create a bitmap for each DC }
  bmAndObject := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndBack := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndMem := CreateCompatibleBitmap(DstDC, DstW, DstH);
  bmSave := CreateCompatibleBitmap(DstDC, SrcW, SrcH);
  { Each DC must select a bitmap object to store pixel data }
  bmBackOld := SelectObject(BackDC, bmAndBack);
  bmObjectOld := SelectObject(ObjectDC, bmAndObject);
  bmMemOld := SelectObject(MemDC, bmAndMem);
  bmSaveOld := SelectObject(SaveDC, bmSave);
  { Select palette }
  palDst := 0; palMem := 0; palSave := 0; palObj := 0;
  if Palette <> 0 then begin
    palDst := SelectPalette(DstDC, Palette, True);
    RealizePalette(DstDC);
    palSave := SelectPalette(SaveDC, Palette, False);
    RealizePalette(SaveDC);
    palObj := SelectPalette(ObjectDC, Palette, False);
    RealizePalette(ObjectDC);
    palMem := SelectPalette(MemDC, Palette, True);
    RealizePalette(MemDC);
  end;
  { Set proper mapping mode }
  SetMapMode(SrcDC, GetMapMode(DstDC));
  SetMapMode(SaveDC, GetMapMode(DstDC));
  { Save the bitmap sent here }
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, SrcDC, SrcX, SrcY, SRCCOPY);
  { Set the background color of the source DC to the color,         }
  { contained in the parts of the bitmap that should be transparent }
  Color := SetBkColor(SaveDC, PaletteColor(TransparentColor));
  { Create the object mask for the bitmap by performing a BitBlt()  }
  { from the source bitmap to a monochrome bitmap                   }
  BitBlt(ObjectDC, 0, 0, SrcW, SrcH, SaveDC, 0, 0, SRCCOPY);
  { Set the background color of the source DC back to the original  }
  SetBkColor(SaveDC, Color);
  { Create the inverse of the object mask }
  BitBlt(BackDC, 0, 0, SrcW, SrcH, ObjectDC, 0, 0, NOTSRCCOPY);
  { Copy the background of the main DC to the destination }
  BitBlt(MemDC, 0, 0, DstW, DstH, DstDC, DstX, DstY, SRCCOPY);
  { Mask out the places where the bitmap will be placed }
  StretchBlt(MemDC, 0, 0, DstW, DstH, ObjectDC, 0, 0, SrcW, SrcH, SRCAND);
  { Mask out the transparent colored pixels on the bitmap }
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, BackDC, 0, 0, SRCAND);
  { XOR the bitmap with the background on the destination DC }
  StretchBlt(MemDC, 0, 0, DstW, DstH, SaveDC, 0, 0, SrcW, SrcH, SRCPAINT);
  { Copy the destination to the screen }
  BitBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, 0, 0,
    SRCCOPY);
  { Restore palette }
  if Palette <> 0 then begin
    SelectPalette(MemDC, palMem, False);
    SelectPalette(ObjectDC, palObj, False);
    SelectPalette(SaveDC, palSave, False);
    SelectPalette(DstDC, palDst, True);
  end;
  { Delete the memory bitmaps }
  DeleteObject(SelectObject(BackDC, bmBackOld));
  DeleteObject(SelectObject(ObjectDC, bmObjectOld));
  DeleteObject(SelectObject(MemDC, bmMemOld));
  DeleteObject(SelectObject(SaveDC, bmSaveOld));
  { Delete the memory DCs }
  DeleteDC(MemDC);
  DeleteDC(BackDC);
  DeleteDC(ObjectDC);
  DeleteDC(SaveDC);
end;

procedure DrawTransparentBitmapRect(DC: HDC; Bitmap: HBitmap; DstX, DstY,
  DstW, DstH: Integer; SrcRect: TRect; TransparentColor: TColorRef);
var
  hdcTemp: HDC;
begin
  hdcTemp := CreateCompatibleDC(DC);
  try
    SelectObject(hdcTemp, Bitmap);
    with SrcRect do
      StretchBltTransparent(DC, DstX, DstY, DstW, DstH, hdcTemp,
        Left, Top, Right - Left, Bottom - Top, 0, TransparentColor);
  finally
    DeleteDC(hdcTemp);
  end;
end;

procedure CopyParentImage(Control: TControl; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
  with Control.Parent do
  begin
    ControlStyle := ControlStyle + [csReplicatable];
    ControlState := ControlState + [csPaintCopy];
  end;
  try
    with Control do begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left; Y := -Top;
    end;
    { Copy parent control image }
    SaveIndex := SaveDC(DC);
    try
      SetViewportOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
        Control.Parent.ClientHeight);
      with TParentControl(Control.Parent) do begin
        Perform(WM_ERASEBKGND, DC, 0);
        PaintWindow(DC);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    { Copy images of graphic controls }
    for I := 0 to Count - 1 do begin
      if Control.Parent.Controls[I] = Control then Break
      else if (Control.Parent.Controls[I] <> nil) and
        Control.Parent.Controls[I].Visible and
        (Control.Parent.Controls[I] is TGraphicControl) then
      begin
        with TGraphicControl(Control.Parent.Controls[I]) do begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) then begin
            ControlStyle := ControlStyle + [csReplicatable];
            ControlState := ControlState + [csPaintCopy];
            SaveIndex := SaveDC(DC);
            try
              SaveIndex := SaveDC(DC);
              SetViewportOrgEx(DC, Left + X, Top + Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
              ControlState := ControlState - [csPaintCopy];
              ControlStyle := ControlStyle - [csReplicatable];
            end;
          end;
        end;
      end;
    end;
  finally
    with Control.Parent do
    begin
      ControlState := ControlState - [csPaintCopy];
      ControlStyle := ControlStyle - [csReplicatable];
    end;
  end;
end;

// Routines from RxLib
////////////////////////////////////////////////////////////////////////////////

{ TEZImageButton }

////////////////////////////////////////////////////////////////////////////////
// Constructor / Destructor

constructor TEZImageButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 121;
  Height := 33;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := GlyphChanged;
  FGlyphNumber := 3;
end;

destructor TEZImageButton.Destroy;
begin
  FGlyph.Free;
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// Messages

procedure TEZImageButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible then
    begin
      Click;
      Result := 1;
    end
    else
      inherited;
end;

procedure TEZImageButton.CMMouseEnter(var Message: TMessage);
begin
  if csLButtonDown in ControlState then
    Self.MouseDown(mbLeft, [ssLeft], 0, 0);
  IsMouseOn := True;
  Paint;
end;

procedure TEZImageButton.CMMouseLeave(var Message: TMessage);
begin
  if csLButtonDown in ControlState then
    Self.MouseUp(mbLeft, [ssLeft], 0, 0);
  IsMouseOn := False;
  Paint;
end;

procedure TEZImageButton.CMTextChanged(var Message: TMessage);
begin
  Paint;
end;

procedure TEZImageButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    IsMouseDown := True;
    Paint;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TEZImageButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  IsMouseDown := False;
  Paint;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TEZImageButton.Paint;
begin
  // Draw as image if Glyph assigned with a valid bitmap
  if FGlyph.Empty or
     (FGlyph.Width < 4) or
     (FGlyph.Height div FGlyphNumber < 4) then
    DrawNormalFrame(Canvas)
  else
    DrawGlyph(Canvas);
end;

////////////////////////////////////////////////////////////////////////////////
// Draw Routines

//------------------------------------------------------------------------------
// Procedure: TEZImageButton.DrawGlyph
// Arguments: ACanvas: TCanvas
// Result:    None
// Comment:   Draw button with image
//------------------------------------------------------------------------------

procedure TEZImageButton.DrawGlyph(ACanvas: TCanvas);
var
  R: TRect;
begin
  // Adjust button size
  Width := FGlyph.Width;
  Height := FGlyph.Height div FGlyphNumber;

  // Get sub-bitmap with button state
  if FGlyphNumber = 1 then
    R := Rect(0, 0, Width, Height)
  else if FGlyphNumber = 2 then
  begin
    if IsMouseDown then
      R := Rect(0, Height, Width, Height * 2)
    else
      R := Rect(0, 0, Width, Height);
  end
  else
  begin
    if IsMouseDown then
      R := Rect(0, Height * 2, Width, Height * 3)
    else if IsMouseOn then
      R := Rect(0, Height, Width, Height * 2)
    else
      R := Rect(0, 0, Width, Height);
  end;

  // Draw
  if FTransparent then
    with TBitmap.Create do
    try
      Width := Self.Width;
      Height := Self.Height;
      CopyParentImage(Self, Canvas);
      DrawTransparentBitmapRect(Canvas.Handle, FGlyph.Handle, 0, 0,
        Width, Height, R, FGlyph.Canvas.Pixels[0, 0]);
      ACanvas.CopyRect(ClientRect, Canvas, ClientRect);
    finally
      Free;
    end
  else
    ACanvas.CopyRect(ClientRect, FGlyph.Canvas, R);
end;

//------------------------------------------------------------------------------
// Procedure: TEZImageButton.DrawNormalFrame
// Arguments: ACanvas: TCanvas
// Result:    None
// Comment:   Draw button with normal frame
//------------------------------------------------------------------------------

procedure TEZImageButton.DrawNormalFrame(ACanvas: TCanvas);
var
  R: TRect;
begin
  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;

    // Draw 3D border
    R := Rect(0, 0, Width, Height);
    if IsMouseDown then
      Frame3D(ACanvas, R, clBtnShadow, clBtnHighLight, 1)
    else
      Frame3D(ACanvas, R, clBtnHighLight, clBtnShadow, 1);

    // Fill surface
    FillRect(Rect(1, 1, Width - 1, Height - 1));
  end;
end;


////////////////////////////////////////////////////////////////////////////////
// Properties

procedure TEZImageButton.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TEZImageButton.SetGlyphNumber(Value: Integer);
begin
  if Value < 1 then
    Value := 1
  else if Value > 3 then
    Value := 3;
  FGlyphNumber := Value;
  Invalidate;
end;

procedure TEZImageButton.SetTransparent(Value: Boolean);
begin
  if FTransparent = Value then
    Exit;
  FTransparent := Value;
  Invalidate;
end;

procedure TEZImageButton.GlyphChanged(Sender: TObject);
begin
  Invalidate;
end;

end.

