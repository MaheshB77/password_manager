const createCardTable = '''
        CREATE TABLE card (
          id TEXT PRIMARY KEY,
          title TEXT,
          card_category_id TEXT,
          card_number TEXT,
          card_holder_name TEXT,
          pin TEXT,
          cvv TEXT,
          issue_date TEXT,
          expiry_date TEXT,
          created_at TEXT,
          updated_at TEXT,

          FOREIGN KEY(card_category_id) REFERENCES card_category(id)
        );
''';