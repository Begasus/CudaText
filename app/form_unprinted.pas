unit form_unprinted;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  IniFiles,
  ATSynEdit,
  proc_globdata,
  proc_msg,
  ATSynEdit_Globals;

type

  { TfmUnprinted }

  TfmUnprinted = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    chkVisible: TCheckBox;
    chkShowWhitespace: TCheckBox;
    chkOnlyInSel: TCheckBox;
    chkAlsoInSel: TCheckBox;
    chkOnlyLeadAndTrail: TCheckBox;
    chkOnlyTrail: TCheckBox;
    chkForceShowTabs: TCheckBox;
    chkShowEndMarks: TCheckBox;
    chkEndDetailed: TCheckBox;
    comboEndMarks: TComboBox;
    LabelEnds: TLabel;
    PanelPreview: TPanel;
    procedure chkAlsoInSelChange(Sender: TObject);
    procedure chkEndDetailedChange(Sender: TObject);
    procedure chkForceShowTabsChange(Sender: TObject);
    procedure chkOnlyInSelChange(Sender: TObject);
    procedure chkOnlyLeadAndTrailChange(Sender: TObject);
    procedure chkOnlyTrailChange(Sender: TObject);
    procedure chkShowEndMarksChange(Sender: TObject);
    procedure chkShowWhitespaceChange(Sender: TObject);
    procedure chkVisibleChange(Sender: TObject);
    procedure comboEndMarksChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Localize;
  public
    EdPreview: TATSynEdit;
    procedure ApplyToEditor(Ed: TATSynEdit);
    procedure UpdateState;
  end;

var
  fmUnprinted: TfmUnprinted;

implementation

{$R *.lfm}

{ TfmUnprinted }

procedure TfmUnprinted.FormCreate(Sender: TObject);
begin
  EdPreview:= TATSynEdit.Create(Self);
  EdPreview.Align:= alClient;
  EdPreview.Parent:= PanelPreview;
  EdPreview.TabStop:= false;
  EdPreview.Font.Name:= EditorOps.OpFontName;
  EdPreview.Font.Size:= EditorOps.OpFontSize;
  EdPreview.Strings.LineAdd('    begin    end    ');
  EdPreview.Strings.LineAdd(#9#9'begin'#9#9'end'#9#9);
  EdPreview.UpdateWrapInfo(true, false);
  EdPreview.OptRulerVisible:= false;
  EdPreview.OptMinimapVisible:= false;
  EdPreview.OptMicromapVisible:= false;
  EdPreview.Show;
end;

procedure TfmUnprinted.chkShowWhitespaceChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkVisibleChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.comboEndMarksChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkOnlyInSelChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkOnlyLeadAndTrailChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkOnlyTrailChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkShowEndMarksChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkAlsoInSelChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkEndDetailedChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.chkForceShowTabsChange(Sender: TObject);
begin
  UpdateState;
end;

procedure TfmUnprinted.FormShow(Sender: TObject);
begin
  Localize;
  UpdateState;
end;

procedure TfmUnprinted.ApplyToEditor(Ed: TATSynEdit);
begin
  Ed.OptUnprintedVisible:= chkVisible.Checked;
  Ed.OptUnprintedSpaces:= chkShowWhitespace.Checked;
  Ed.OptUnprintedEnds:= chkShowEndMarks.Checked;
  Ed.OptUnprintedEndsDetails:= chkEndDetailed.Checked;
  Ed.OptUnprintedSpacesTrailing:= chkOnlyTrail.Checked;
  Ed.OptUnprintedSpacesBothEnds:= chkOnlyLeadAndTrail.Checked;
  Ed.OptUnprintedSpacesOnlyInSelection:= chkOnlyInSel.Checked;
  Ed.OptUnprintedSpacesAlsoInSelection:= chkAlsoInSel.Checked;
  Ed.OptUnprintedForceTabs:= chkForceShowTabs.Checked;

  if comboEndMarks.ItemIndex>=0 then
    ATEditorOptions.UnprintedEndSymbol:= TATEditorUnptintedEolSymbol(comboEndMarks.ItemIndex);

  Ed.Update;
end;

procedure TfmUnprinted.UpdateState;
begin
  ApplyToEditor(EdPreview);

  chkOnlyLeadAndTrail.Enabled:= not chkOnlyInSel.Checked;
  chkOnlyTrail.Enabled:= not chkOnlyInSel.Checked and not chkOnlyLeadAndTrail.Checked;
  chkAlsoInSel.Enabled:= not chkOnlyInSel.Checked;

  comboEndMarks.Enabled:= not chkEndDetailed.Checked;
end;

procedure TfmUnprinted.Localize;
const
  section = 'd_unpri';
var
  ini: TIniFile;
  fn: string;
begin
  fn:= AppFile_Language;
  if not FileExists(fn) then exit;
  ini:= TIniFile.Create(fn);
  try
    Caption:= ini.ReadString(section, '_', Caption);
    with btnOk do Caption:= msgButtonOk;
    with btnCancel do Caption:= msgButtonCancel;
    with chkVisible do Caption:= ini.ReadString(section, 'vis', Caption);
    with chkShowWhitespace do Caption:= ini.ReadString(section, 'sh_sp', Caption);
    with chkOnlyInSel do Caption:= ini.ReadString(section, 'only_sel', Caption);
    with chkAlsoInSel do Caption:= ini.ReadString(section, 'also_sel', Caption);
    with chkOnlyLeadAndTrail do Caption:= ini.ReadString(section, 'only_l_tr', Caption);
    with chkOnlyTrail do Caption:= ini.ReadString(section, 'only_tr', Caption);
    with chkForceShowTabs do Caption:= ini.ReadString(section, 'sh_tabs', Caption);
    with chkShowEndMarks do Caption:= ini.ReadString(section, 'sh_end', Caption);
    with chkEndDetailed do Caption:= ini.ReadString(section, 'end_det', Caption);
    with LabelEnds do Caption:= ini.ReadString(section, 'ends', Caption);
    with comboEndMarks do Items[0]:= ini.ReadString(section, 'end_dot', Caption);
    with comboEndMarks do Items[1]:= ini.ReadString(section, 'end_arr', Caption);
    with comboEndMarks do Items[2]:= ini.ReadString(section, 'end_pil', Caption);
  finally
    FreeAndNil(ini);
  end;
end;

end.
