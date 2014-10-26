ALTER TABLE je_lines DROP CONSTRAINT IF EXISTS je_lines_updated_by_fkey;

DROP TABLE IF EXISTS je_lines;

ALTER TABLE journal_entries DROP CONSTRAINT IF EXISTS journal_entries_created_by_fkey;
ALTER TABLE journal_entries DROP CONSTRAINT IF EXISTS journal_entries_updated_by_fkey;
ALTER TABLE journal_entries DROP CONSTRAINT IF EXISTS journal_entries_period_id_fkey;
DROP TABLE IF EXISTS journal_entries;

ALTER TABLE periods DROP CONSTRAINT IF EXISTS periods_created_by_fkey;
ALTER TABLE periods DROP CONSTRAINT IF EXISTS periods_updated_by_fkey;
DROP TABLE IF EXISTS periods;

ALTER TABLE accounts DROP CONSTRAINT IF EXISTS accounts_created_by_fkey;
ALTER TABLE accounts DROP CONSTRAINT IF EXISTS accounts_updated_by_fkey;
ALTER TABLE accounts DROP CONSTRAINT IF EXISTS accounts_account_type_id_fkey;
DROP TABLE IF EXISTS accounts;

ALTER TABLE account_types DROP CONSTRAINT IF EXISTS accounts_created_by_fkey;
ALTER TABLE account_types DROP CONSTRAINT IF EXISTS accounts_updated_by_fkey;
DROP TABLE IF EXISTS account_types;


ALTER TABLE users DROP CONSTRAINT IF EXISTS users_created_by_fkey;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_updated_by_fkey;
DROP TABLE IF EXISTS users;

CREATE OR REPLACE FUNCTION update_version_and_updated_at()
  RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = now();
      NEW.version = OLD.version + 1;
      RETURN NEW;
    END;
  $$ language 'plpgsql';

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  user_name VARCHAR(255) UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL
    CHECK (email ~* '\A[[:alnum:]_\-\.]+@[a-z[:digit:]\-\.]+\.[a-z]+'),
  created_by INTEGER NOT NULL,
  updated_by INTEGER NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  updated_at timestamp NOT NULL DEFAULT current_timestamp,
  version INTEGER NOT NULL DEFAULT 0
);

INSERT INTO users(user_name, email, created_by, updated_by) VALUES('super_user','lbmaxwell@gmail.com', 1,1);

CREATE TRIGGER trg_users_update
  BEFORE UPDATE ON users FOR EACH ROW
    EXECUTE PROCEDURE update_version_and_updated_at();

ALTER TABLE users ADD CONSTRAINT users_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE users ADD CONSTRAINT users_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES users(id);

CREATE TABLE account_types (
  id SERIAL PRIMARY KEY,
  account_type VARCHAR(255) UNIQUE NOT NULL,
  created_by INTEGER NOT NULL,
  updated_by INTEGER NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  updated_at timestamp NOT NULL DEFAULT current_timestamp,
  version INTEGER NOT NULL DEFAULT 0
);

CREATE TRIGGER trg_account_types_update
  BEFORE UPDATE ON account_types FOR EACH ROW
    EXECUTE PROCEDURE update_version_and_updated_at();

ALTER TABLE account_types ADD CONSTRAINT account_types_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE account_types ADD CONSTRAINT account_types_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES users(id);
  
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  number VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) UNIQUE NOT NULL,
  active BOOLEAN NOT NULL,
  account_type_id INT NOT NULL,
  created_by INTEGER NOT NULL,
  updated_by INTEGER NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  updated_at timestamp NOT NULL DEFAULT current_timestamp,
  version INTEGER NOT NULL DEFAULT 0
);

CREATE TRIGGER trg_accounts_update
  BEFORE UPDATE ON accounts FOR EACH ROW
    EXECUTE PROCEDURE update_version_and_updated_at();

ALTER TABLE accounts ADD CONSTRAINT accounts_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE accounts ADD CONSTRAINT accounts_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES users(id);

ALTER TABLE accounts ADD CONSTRAINT accounts_account_type_id_fkey
  FOREIGN KEY (account_type_id) REFERENCES account_types(id);

CREATE TABLE periods (
  id SERIAL PRIMARY KEY,
  first_day DATE NOT NULL,
  last_day DATE NOT NULL,
  fiscal_year INT NOT NULL,
  number_in_fiscal_year INT NOT NULL,
  open BOOLEAN NOT NULL,
  created_by INTEGER NOT NULL,
  updated_by INTEGER NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  updated_at timestamp NOT NULL DEFAULT current_timestamp,
  version INTEGER NOT NULL DEFAULT 0
);

CREATE TRIGGER trg_periods_update
  BEFORE UPDATE ON periods FOR EACH ROW
    EXECUTE PROCEDURE update_version_and_updated_at();

ALTER TABLE periods ADD CONSTRAINT periods_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE periods ADD CONSTRAINT periods_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES users(id);
  
CREATE TABLE journal_entries (
  id SERIAL PRIMARY KEY,
  je_number VARCHAR(255) UNIQUE NOT NULL,
  debit_total MONEY NOT NULL,
  credit_total MONEY NOT NULL,
  period_id INTEGER NOT NULL,
  accounting_date DATE NOT NULL,
  description VARCHAR(1024),
  reversal_id INT,
  created_by INTEGER NOT NULL,
  updated_by INTEGER NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  updated_at timestamp NOT NULL DEFAULT current_timestamp,
  version INTEGER NOT NULL DEFAULT 0
);

CREATE TRIGGER trg_journal_entries_update
  BEFORE UPDATE ON journal_entries FOR EACH ROW
    EXECUTE PROCEDURE update_version_and_updated_at();

ALTER TABLE journal_entries ADD CONSTRAINT journal_entries_period_id_fkey
  FOREIGN KEY (period_id) REFERENCES periods(id);

ALTER TABLE journal_entries ADD CONSTRAINT journal_entries_created_by_fkey
  FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE journal_entries ADD CONSTRAINT journal_entries_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES users(id);


CREATE TABLE je_lines (
  id SERIAL PRIMARY KEY,
  journal_entry_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  debit_amount MONEY NOT NULL DEFAULT 0.00,
  credit_amount MONEY NOT NULL DEFAULT 0.00,
  updated_at timestamp NOT NULL DEFAULT current_timestamp,
  version INTEGER NOT NULL DEFAULT 0);

ALTER TABLE je_lines ADD CONSTRAINT je_lines_journal_entry_id
  FOREIGN KEY (journal_entry_id) REFERENCES journal_entries(id);

CREATE TRIGGER trg_je_lines_update
  BEFORE UPDATE ON je_lines FOR EACH ROW
    EXECUTE PROCEDURE update_version_and_updated_at();


