   CREATE 
   SCHEMA conversa;

      USE conversa;
      
   CREATE 
    TABLE perfil
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , descricao   VARCHAR(100) NOT NULL
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE conversa_tipo
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , descricao   VARCHAR(100)
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE anexo_tipo
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , descricao   VARCHAR(100)
        , tipo        VARCHAR(50)
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE mensagem_evento_tipo
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , descricao   VARCHAR(100)        
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );

   CREATE 
    TABLE conversa
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , descricao   VARCHAR(100) NOT NULL
        , tipo        INTEGER NOT NULL
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE usuario
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , nome        VARCHAR(200) NOT NULL
        , apelido     VARCHAR(50)  NOT NULL
        , email       VARCHAR(100) NOT NULL
		, usuario     VARCHAR(50)  NOT NULL
        , senha       VARCHAR(50)  NOT NULL
        , perfil_id   INTEGER NOT NULL
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE conversa_usuario
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , usuario_id  INTEGER NOT NULL
        , conversa_id INTEGER NOT NULL
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
	
   CREATE 
    TABLE contato
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , usuario_id  INTEGER NOT NULL
        , contato_id  INTEGER NOT NULL
        , favorito    INTEGER
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE mensagem
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , mensagem_id INTEGER
        , usuario_id  INTEGER NOT NULL
        , conversa_id INTEGER NOT NULL
        , resposta    INTEGER
        , confirmacao INTEGER
        , conteudo    BLOB
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE mensagem_evento
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , usuario_id  INTEGER NOT NULL
        , mensagem_id INTEGER NOT NULL
        , tipo        INTEGER NOT NULL
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );
        
   CREATE 
    TABLE mensagem_confirmacao
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , usuario_id  INTEGER NOT NULL
        , mensagem_id INTEGER NOT NULL
        , confirmado  DATETIME NOT NULL
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );        
        
   CREATE 
    TABLE mensagem_anexo
        ( id          INTEGER AUTO_INCREMENT PRIMARY KEY
        , mensagem_id INTEGER NOT NULL
        , tipo        INTEGER NOT NULL
        , local       VARCHAR(500)
        , tamanho     INTEGER
        , incluido_id INTEGER NOT NULL
        , incluido_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        , alterado_id INTEGER DEFAULT NULL
        , alterado_em DATETIME DEFAULT NULL
        , excluido_id INTEGER DEFAULT NULL
        , excluido_em DATETIME DEFAULT NULL
        ) 
     WITH 
   SYSTEM VERSIONING
PARTITION 
       BY SYSTEM_TIME 
        ( PARTITION historico HISTORY
		, PARTITION atual CURRENT
        );