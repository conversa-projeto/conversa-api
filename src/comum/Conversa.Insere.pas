// Eduardo - 13/07/2020

unit Conversa.Insere;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  FireDAC.Comp.Client;

{$Region' Ajuda '}
(*
 - Exemplo do json para inserção de multiplas tabelas com id's auto-incremento fazendo o relacionamento

/// SQL
create
 table pai
     ( id int auto_increment primary key
     , descricao varchar(100)
     );

create
 table filha
     ( id int auto_increment primary key
     , pai_id int
     , descricao varchar(100)
     );

create
 table neta
     ( id int auto_increment primary key
     , filha_id int
     , descricao varchar(100)
     );

var
  jaComando: TJSONArray;
begin
  jaComando := TJSONArray.Create;
  try
    jaComando.Add(
      TJSONObject.Create.AddPair(
        'pai',
        TJSONArray.Create.Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-1)))
            .AddPair('descricao', 'pai')
        ).Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-2)))
            .AddPair('descricao', 'mae')
        )
      )
    ).Add(
      TJSONObject.Create.AddPair(
        'filha',
        TJSONArray.Create.Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-3)))
            .AddPair('pai_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-1)))
            .AddPair('descricao', 'filha')
        ).Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-4)))
            .AddPair('pai_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-2)))
            .AddPair('descricao', 'filho')
        )
      )
    ).Add(
      TJSONObject.Create.AddPair(
        'neta',
        TJSONArray.Create.Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-5)))
            .AddPair('filha_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-3)))
            .AddPair('descricao', 'neto')
        ).Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-6)))
            .AddPair('filha_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-3)))
            .AddPair('descricao', 'netinho')
        ).Add(
          TJSONObject.Create
            .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-7)))
            .AddPair('filha_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-4)))
            .AddPair('descricao', 'netao')
        )
      )
    );
  finally
    FreeAndNil(jaComando);
  end;
*)
{$EndRegion}

type
  TInsere = class
  private
    FPrimaria: TArray<Int64>;
    FEstrangeira: TArray<Int64>;
    FjaComandos: TJSONArray;
    FConnection: TFDConnection;
    function PosicaoNaLista(const aLista: TArray<Int64>; const  iItem: Int64; out iIndice: Integer): Boolean;
  public
    constructor Create(jaJSON: TJSONArray; conn: TFDConnection);
    destructor Destroy; override;
    procedure Executar(jaRetorno: TJSONArray); overload;
    function Executar: TJSONArray; overload;
  end;

implementation

uses
  System.StrUtils;

{ TInsere }

constructor TInsere.Create(jaJSON: TJSONArray; conn: TFDConnection);
begin
  FjaComandos := TJSONArray(jaJSON.Clone);
  FConnection := conn;
end;

destructor TInsere.Destroy;
begin
  FreeAndNil(FjaComandos);
  inherited;
end;

function TInsere.PosicaoNaLista(const aLista: TArray<Int64>; const  iItem: Int64; out iIndice: Integer): Boolean;
var
  I: Integer;
begin
  iIndice := -1;
  Result := False;
  for I := Low(aLista) to High(aLista) do
    if aLista[I] = iItem then
    begin
      iIndice := I;
      Result := True;
      Break;
    end;
end;

function TInsere.Executar: TJSONArray;
begin
  Result := TJSONArray.Create;
  Executar(Result);
end;

procedure TInsere.Executar(jaRetorno: TJSONArray);
var
  jvTabela: TJSONValue;
  jvRegistros: TJSONValue;
  jvIdentificador: TJSONPair;
  I: Integer;
  iItem: Integer;
  sCampos: String;
  sValores: String;
  bPrimaria: Boolean;
  qry: TFDQuery;
  joTabela: TJSONObject;
  jaRegistros: TJSONArray;
  joLinha: TJSONObject;
  jpPrimaria: TJSONPair;
  jpEstrangeira: TJSONPair;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConnection;
    FConnection.StartTransaction;
    try
      for jvTabela in FjaComandos do
      begin 
        joTabela := TJSONObject.Create;
        jaRetorno.AddElement(joTabela);
        jaRegistros := TJSONArray.Create;
        joTabela.AddPair(TJSONObject(jvTabela).Pairs[0].JsonString.Value, jaRegistros);      
        for jvRegistros in TJSONArray(TJSONObject(jvTabela).Pairs[0].JsonValue) do
        begin
          sCampos := EmptyStr;
          sValores := EmptyStr;
          bPrimaria := False;
          jpPrimaria := nil;
          jpEstrangeira := nil;
          joLinha := TJSONObject.Create;
          jaRegistros.AddElement(joLinha);
          for I := 0 to Pred(TJSONObject(jvRegistros).Count) do
          begin
            if TJSONObject(jvRegistros).Pairs[I].JsonValue is TJSONObject then
            begin
              jvIdentificador := TJSONObject(TJSONObject(jvRegistros).Pairs[I].JsonValue).Pairs[0];
              if jvIdentificador.JsonString.Value.Equals('primaria') then
              begin
                if bPrimaria then
                  raise Exception.Create('Multiplas chaves primárias na inserção!');
                bPrimaria := True;
                if PosicaoNaLista(FPrimaria, TJSONNumber(jvIdentificador.JsonValue).AsInt64, iItem) then
                  raise Exception.Create('Chave primária temporária duplicada!');
                SetLength(FPrimaria, Succ(Length(FPrimaria)));
                FPrimaria[Pred(Length(FPrimaria))] := TJSONNumber(jvIdentificador.JsonValue).AsInt64;
                jpPrimaria := TJSONPair.Create(
                  TJSONObject(jvRegistros).Pairs[I].JsonString.Value, 
                  TJSONObject.Create.AddPair('antes', TJSONNumber.Create(TJSONNumber(jvIdentificador.JsonValue).AsInt64))
                );                                                                                                      
                Continue;
              end
              else
              if jvIdentificador.JsonString.Value.Equals('estrangeira') then
              begin
                if PosicaoNaLista(FPrimaria, TJSONNumber(jvIdentificador.JsonValue).AsInt64, iItem) then
                begin
                  sValores := IfThen(not sValores.IsEmpty, sValores +', ') + FloatToStr(FEstrangeira[iItem]);
                  jpEstrangeira :=
                    TJSONPair.Create(
                      TJSONObject(jvRegistros).Pairs[I].JsonString.Value, 
                      TJSONObject.Create
                        .AddPair('antes', TJSONNumber.Create(TJSONNumber(jvIdentificador.JsonValue).AsInt64))
                        .AddPair('atual', TJSONNumber.Create(FEstrangeira[iItem])) 
                  );            
                end
                else
                  raise Exception.Create('Chave estrangeira não encontrada!');
              end
              else
                raise Exception.Create('Tipo de chave não esperado: '+ jvIdentificador.JsonString.Value);
            end
            else
            begin
              if TJSONObject(jvRegistros).Pairs[I].JsonValue is TJSONString then
                sValores := IfThen(not sValores.IsEmpty, sValores +', ') + QuotedStr(TJSONObject(jvRegistros).Pairs[I].JsonValue.Value)
              else
              if TJSONObject(jvRegistros).Pairs[I].JsonValue is TJSONNumber then
                sValores := IfThen(not sValores.IsEmpty, sValores +', ') + ReplaceStr(FloatToStr(TJSONNumber(TJSONObject(jvRegistros).Pairs[I].JsonValue).AsDouble), ',', '.')
              else
              if TJSONObject(jvRegistros).Pairs[I].JsonValue is TJSONNull then
                sValores := IfThen(not sValores.IsEmpty, sValores +', ') +'null';
            end;
            sCampos := IfThen(not sCampos.IsEmpty, sCampos +', ') + TJSONObject(jvRegistros).Pairs[I].JsonString.Value;
          end;
          qry.Close;
          qry.Open(
            'insert '+
            '  into '+ TJSONObject(jvTabela).Pairs[0].JsonString.Value +
            '     ( '+ sCampos +' ) '+
            'values '+
            '     ( '+ sValores +' ); '+
            ' select '+ IfThen(bPrimaria, 'LAST_INSERT_ID()', '0') +' as id '
          );
          if bPrimaria then
          begin
            SetLength(FEstrangeira, Succ(Length(FEstrangeira)));
            FEstrangeira[Pred(Length(FEstrangeira))] := qry.FieldByName('id').AsLargeInt;           
            TJSONObject(jpPrimaria.JsonValue).AddPair('atual', TJSONNumber.Create(qry.FieldByName('id').AsLargeInt));
            joLinha.AddPair(jpPrimaria);            
          end;
          if Assigned(jpEstrangeira) then
            joLinha.AddPair(jpEstrangeira);
        end;
      end;
      FConnection.Commit;
    except on E: Exception do
      begin
        FConnection.Rollback;
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

end.
