object ConversaDados: TConversaDados
  OldCreateOrder = False
  Height = 107
  Width = 167
  object conMariaDB: TFDConnection
    Params.Strings = (
      'Database=conversa'
      'Password=sql@dev'
      'User_Name=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object qryMariaDB: TFDQuery
    Connection = conMariaDB
    Left = 104
    Top = 32
  end
end
