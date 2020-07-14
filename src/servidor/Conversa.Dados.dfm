object ConversaDados: TConversaDados
  OldCreateOrder = False
  Height = 105
  Width = 98
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
end
