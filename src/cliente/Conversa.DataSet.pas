// Eduardo - 06/07/2020

unit Conversa.DataSet;

interface

uses
  System.SysUtils,
  System.JSON,
  Data.DB,
  Datasnap.DBClient,
  Conversa.Consulta;

type
  TClientDataSet = class(Datasnap.DBClient.TClientDataSet)
  private
    FRESTState: TDataSetState;
    FFieldCount: Integer;
    aChanged: TArray<Boolean>;
    aOnValidate: TArray<TFieldNotifyEvent>;
    FNotAdd: Integer;
    FMethodGet: TFunc<TConsulta, TJSONArray>;
    FMethodPut: TFunc<TJSONObject, TJSONObject>;
    FMethodPost: TFunc<TJSONObject, TJSONObject>;
    FMethodDelete: TProc;
    procedure LoadFromJSONArray(aJSON : TJSONArray);
    procedure FieldOnValidate(Sender: TField);
  public
    function WSCreate: TClientDataSet;
    function WSSetGet(pProc: TFunc<TConsulta, TJSONArray>): TClientDataSet;
    function WSSetPut(pProc: TFunc<TJSONObject, TJSONObject>): TClientDataSet;
    function WSSetPost(pProc: TFunc<TJSONObject, TJSONObject>): TClientDataSet;
    function WSSetDelete(pProc: TProc): TClientDataSet;
    function WSOpen(consulta: TConsulta): TClientDataSet;
    function WSClose: TClientDataSet;
    function WSAppend: TClientDataSet;
    function WSEdit: TClientDataSet;
    function WSPost: TClientDataSet;
    function WSCancel: TClientDataSet;
    function WSDelete: TClientDataSet;
    property WSState: TDataSetState read FRESTState;
  end;

const
  sl = sLineBreak;

implementation

uses
  REST.Response.Adapter,
  System.RTTI,
  System.Generics.Collections,
  System.DateUtils,
  IdURI;

{ TClientDataSet }

function TClientDataSet.WSCreate: TClientDataSet;
var
  I: Integer;
begin
  if not Self.ProviderName.IsEmpty then
    raise Exception.Create(Self.Name +': REST só disponível para ClientDataSet temporário!');

  Result := Self;

  // Armazena a quantidade de fields do ClientDataSet
  FFieldCount := Self.FieldCount;
  FNotAdd     := 0;

  // Se não tem fields não cria agora
  if FFieldCount = 0 then
    Exit;

  // Cria o DataSet
  Self.CreateDataSet;

  // Cria arrays para armazenar os dados dos fields
  SetLength(aOnValidate, FFieldCount);
  SetLength(aChanged,    FFieldCount);

  // Sobrescreve eventos dos fields
  for I := 0 to Pred(FFieldCount) do
  begin
    // Armazena os eventos originais do field e sobescreve
    aOnValidate[I] := Self.Fields[I].OnValidate;
    Self.Fields[I].OnValidate := FieldOnValidate;
  end;
end;

function TClientDataSet.WSSetGet(pProc: TFunc<TConsulta, TJSONArray>): TClientDataSet;
begin
  Result := Self;
  FMethodGet := pProc;
end;

function TClientDataSet.WSSetPut(pProc: TFunc<TJSONObject, TJSONObject>): TClientDataSet;
begin
  Result := Self;
  FMethodPut := pProc;
end;

function TClientDataSet.WSSetPost(pProc: TFunc<TJSONObject, TJSONObject>): TClientDataSet;
begin
  Result := Self;
  FMethodPost := pProc;
end;

function TClientDataSet.WSSetDelete(pProc: TProc): TClientDataSet;
begin
  Result := Self;
  FMethodDelete := pProc;
end;

procedure TClientDataSet.FieldOnValidate(Sender: TField);
var
  I: Integer;
begin
  // Obtem a posição dos dados do field nos arrays
  I := Sender.Index;
  // Se tem evento de validação para ser executado, executa
  if Assigned(aOnValidate[I]) then
    aOnValidate[I](Sender);
  // Define que os dados do field foram alterados
  aChanged[I] := True;
end;

procedure TClientDataSet.LoadFromJSONArray(aJSON : TJSONArray);
var
  adJSON : TCustomJSONDataSetAdapter;
begin
  // Cria adaptador
  adJSON := TCustomJSONDataSetAdapter.Create(nil);
  try
    // Informa o ClientDataSet que vai receber os dados
    adJSON.Dataset := TDataSet(Self);
    // Executa
    adJSON.UpdateDataSet(aJSON);
  finally
    // Limpa da memória
    FreeAndNil(adJSON);
  end;
end;

function TClientDataSet.WSOpen(consulta: TConsulta): TClientDataSet;
var
  I,J          : Integer;
  DField       : TField;
  aJSONTBL     : TJSONArray;
  oJSONROW     : TJSONObject;
  oJSONCEL     : TJSONPair;
  RBeforePost  : TDataSetNotifyEvent;
  ROnNewRecord : TDataSetNotifyEvent;
  ROnPosError  : TDataSetErrorEvent;
  aOnChange    : Array of TFieldNotifyEvent;
  aOnSetText   : Array of TFieldSetTextEvent;
  aOnValidate  : Array of TFieldNotifyEvent;
begin
  Result := Self;

  // Se estiver ativo, limpa os dados atuais
  if Self.Active then
    Self.EmptyDataSet;

  if not Assigned(FMethodGet) then
    raise Exception.Create('Metodo Get não definido!');

  // Executa chamada e obtem o retorno
  try
    aJSONTBL := FMethodGet(consulta);
  finally
    FreeAndNil(consulta);
  end;
  try
    // Se o ClientDataSet não possui campos
    if FFieldCount = 0 then
    begin
      // Carrega campos da consulta
      Self.LoadFromJSONArray(aJSONTBL);

      // Posiciona no primeiro registro
      if not Self.IsEmpty then
        Self.First;

      // Coloca o ClientDataSet em estado de Navegacao
      Self.FRESTState := dsBrowse;

      // Sai da função
      Exit;
    end;

    // Remove eventos do dataset
    RBeforePost      := Self.BeforePost;
    ROnNewRecord     := Self.OnNewRecord;
    ROnPosError      := Self.OnPostError;
    Self.BeforePost  := nil;
    Self.OnNewRecord := nil;
    Self.OnPostError := nil;
    try
      // Cria arrays para armazenar os eventos dos fields
      SetLength(aOnChange   ,FFieldCount);
      SetLength(aOnSetText  ,FFieldCount);
      SetLength(aOnValidate ,FFieldCount);

      // Sobrescreve eventos dos fields
      for I := 0 to Pred(FFieldCount) do
      begin
        DField            := Self.Fields[I];
        aOnChange[I]      := DField.OnChange;
        aOnSetText[I]     := DField.OnSetText;
        aOnValidate[I]    := DField.OnValidate;
        DField.OnChange   := nil;
        DField.OnSetText  := nil;
        DField.OnValidate := nil;
      end;

      // Desativa os controles para não executar os eventos do DataSource
      Self.DisableControls;
      try
        // Passar por todas as linhas da tabela
        for I := 0 to Pred(aJSONTBL.Count) do
        begin
          // Insere no dataset
          Self.Append;

          // Obtem a linha
          oJSONROW := TJSONObject(aJSONTBL.Items[I]);

          // Passa por todas as colunas
          for J := 0 to Pred(oJSONROW.Count) do
          begin
            // Obtem a célula
            oJSONCEL := oJSONROW.Pairs[J];

            // Obtem o field do dataset correspondente ao nome do par JSON
            DField := Self.FindField(oJSONCEL.JsonString.Value);

            // Se existe o field
            if DField <> nil then
            begin
              // Veifica se não é nulo
              if not (oJSONCEL.JsonValue is TJSONNull) then
              begin
                // Formata o valor de acordo com o tipo do field
                if DField is TNumericField then
                  DField.AsFloat := StrToFloat(oJSONCEL.JsonValue.Value)
                else
                if not(DField is TTimeField) and
                  ((DField is TDateTimeField) or (DField is TSQLTimeStampField)) then
                  DField.Value := ISO8601ToDate(oJSONCEL.JsonValue.Value)
                else
                  DField.AsString := oJSONCEL.JsonValue.Value;
              end;
            end;
          end;
        end;
      finally
        // Reinsere evento original dos fields
        for I := 0 to Pred(FFieldCount) do
        begin
          DField            := Self.Fields[I];
          DField.OnChange   := aOnChange[I];
          DField.OnSetText  := aOnSetText[I];
          DField.OnValidate := aOnValidate[I];
        end;

        // Ativa os controles
        Self.EnableControls;

        // Passa pelo StateChange do DataSource
        Self.First;
      end;
    finally
      // Reatribui eventos do dataset
      Self.BeforePost  := RBeforePost;
      Self.OnNewRecord := ROnNewRecord;
      Self.OnPostError := ROnPosError;
    end;
    // Coloca o ClientDataSet em estado de Navegacao
    Self.FRESTState := dsBrowse;
  finally
    FreeAndNil(aJSONTBL);
  end;
end;

function TClientDataSet.WSClose: TClientDataSet;
begin
  Result  := Self;
  if Self.Active then
    Self.EmptyDataSet;
end;

function TClientDataSet.WSAppend: TClientDataSet;
begin
  Result := Self;
  Self.Append;
  Self.FRESTState := dsInsert;
  // Inicializa informação sobre alteração dos dados
  Finalize(aChanged);
  SetLength(aChanged, FFieldCount);
end;

function TClientDataSet.WSEdit: TClientDataSet;
begin
  Result := Self;
  Self.Edit;
  Self.FRESTState := dsEdit;
  // Inicializa informação sobre alteração dos dados
  Finalize(aChanged);
  SetLength(aChanged, FFieldCount);
end;

function TClientDataSet.WSPost: TClientDataSet;
var
  I           : Integer;
  oJSON       : TJSONObject;
  oRETURN     : TJSONObject;
  RField      : TField;
  RBeforePost : TDataSetNotifyEvent;
  ROnPosError : TDataSetErrorEvent;
  ROnChange   : TFieldNotifyEvent;
  ROnSetText  : TFieldSetTextEvent;
  ROnValidate : TFieldNotifyEvent;
  OleData     : OleVariant;
begin
  Result := Self;

  // Se estiver inserindo ou editando
  if FRESTState in [dsInsert, dsEdit] then
  begin
    try
      // Executa validação dos dados
      Self.Post;
    except on E: Exception do
      begin
        // Volta para edicao, caso der erro, ja estara em edicao
        Self.Edit;

        // Retorna mensagem de erro original
        raise EAbort.Create(E.Message);
      end;
    end;
  end
  else
  begin
    // Se não for tratado, o registro não será gravado e o usuário não será avisado
    raise Exception.Create(Self.Name +': Registro não está em edição!');
  end;

  // Executa evento antes de enviar os dados ao servidor
  OleData := Self.Data;
  if Assigned(Self.BeforeApplyUpdates) then
    Self.BeforeApplyUpdates(Self, OleData);

  oJSON := TJSONObject.Create;
  try
    // Obtem os dados do cds
    for I := 0 to Pred(FFieldCount) do
    begin
      // Será enviado ao Servidor apenas fields do tipo fkData
      if Self.Fields[I].FieldKind <> fkData then
        Continue;

      // Se o campo não é Update, Where e nem Key, não será enviado ao Servidor
      if (Self.Fields[I].ProviderFlags * [pfInUpdate, pfInWhere, pfInKey]) = [] then
        Continue;

      // Inserção envia todos os campos
      if (FRESTState = dsEdit)                                              and  // Se for edição
         (not aChanged[Self.Fields[I].Index])                               and  // Se o campo não foi alterado
         (not ((Self.Fields[I].ProviderFlags * [pfInWhere, pfInKey]) = [])) then // Se não é where nem key
        Continue;

      // Converter para tipo correto
      if Self.Fields[I].IsNull then
        oJSON.AddPair(Self.Fields[I].FieldName, TJSONNull.Create)
      else
      if Self.Fields[I] is TStringField then
        oJSON.AddPair(Self.Fields[I].FieldName, Self.Fields[I].AsString)
      else
      if Self.Fields[I] is TNumericField then
        oJSON.AddPair(Self.Fields[I].FieldName, TJSONNumber.Create(Self.Fields[I].AsFloat))
      else
      if (Self.Fields[I] is TDateTimeField) or (Self.Fields[I] is TSQLTimeStampField) then
        oJSON.AddPair(Self.Fields[I].FieldName, DateToISO8601(Self.Fields[I].AsDateTime))
      else
        raise Exception.Create(Self.Name +': Tipo do campo não esperado!'+ sl +'Campo: '+ Self.Fields[I].FieldName +' - Tipo: '+ TRTTIEnumerationType.GetName(Self.Fields[I].DataType));
    end;

    // Se está enviando somente o id
    if oJSON.Count = 1 then
    begin
      // Informa que o processo requisitado foi concluído
      Self.FRESTState := dsBrowse;
      Exit;
    end;

    // Envia ao servidor
    try
      case FRESTState of
        dsInsert:
        begin
          if Assigned(FMethodPut) then
            oRETURN := FMethodPut(oJSON)
          else
            raise Exception.Create('Metodo Put não definido!')
        end;
        dsEdit:
        begin
          if Assigned(FMethodPost) then
            oRETURN := FMethodPost(oJSON)
          else
            raise Exception.Create('Metodo Post não definido!')
        end;
      end;

      // Passa por todos os campos informando que não estão mais alterados
      Finalize(aChanged);
      SetLength(aChanged, FFieldCount);

      // Se for inserção, o servidor irá retornar o registro para os campos auto incremento do banco
      if FRESTState = dsInsert then
      begin
        // Armazena eventos originais
        RBeforePost      := Self.BeforePost;
        ROnPosError      := Self.OnPostError;
        Self.BeforePost  := nil;
        Self.OnPostError := nil;
        try
          // Insere os dados no cds
          Self.Edit;

          // Passar por todas os campos retornados pelo servidor
          for I := 0 to Pred(oRETURN.Count) do
          begin
            // Atribui field
            RField := Self.FindField(oRETURN.Pairs[I].JSONString.Value);
            if RField <> nil then
            begin
              // Armazena evntos do field
              ROnChange         := RField.OnChange;
              ROnSetText        := RField.OnSetText;
              ROnValidate       := RField.OnValidate;
              RField.OnChange   := nil;
              RField.OnSetText  := nil;
              RField.OnValidate := nil;
              try
                RField.AsString := oRETURN.Pairs[I].JSONValue.Value;
              finally
                // Reatribui os eventos do field
                RField.OnChange   := ROnChange;
                RField.OnSetText  := ROnSetText;
                RField.OnValidate := ROnValidate;
              end;
            end;
          end;

          // Posta informações
          Self.Post;
        finally
          // Reatribui eventos do dataset
          Self.BeforePost  := RBeforePost;
          Self.OnPostError := ROnPosError;
        end;
      end;

      // Informa que o processo requisitado foi concluído
      Self.FRESTState := dsBrowse;
    finally
      FreeAndNil(oRETURN);
    end;
  finally
    FreeAndNil(oJSON);
  end;

  // Executa evento depois de enviar os dados ao servidor
  OleData := Self.Data;
  if Assigned(Self.AfterApplyUpdates) then
    Self.AfterApplyUpdates(Self, OleData);
end;

function TClientDataSet.WSCancel: TClientDataSet;
begin
  Result := Self;

  // Cancela as alterações do registro atual
  Self.Cancel;

  // Atualiza o tipo de requisição do usuário
  Self.FRESTState := dsBrowse;
end;

function TClientDataSet.WSDelete: TClientDataSet;
begin
  Result := Self;

  if not Assigned(FMethodDelete) then
    raise Exception.Create('Metodo Delete não definido!');

  FMethodDelete;

  // Deleta o registro do cds
  Self.Delete;

  // Atualiza o tipo de requisição do usuário
  Self.FRESTState := dsBrowse;
end;

end.