# frozen_string_literal: true

# создание таблиц и их наполнение
module Generator
  require 'faker'

  # основной метод модуля
  def create_queries
    File.open('script.sql', 'w') do |file|
      create_tables(file)
    end

    insert_into
  end

  # метод создания всех таблиц
  def create_tables(file)
    create_table_clients(file)
    create_table_banned_clients(file)
    create_table_speech_therapists(file)
    create_table_services(file)
    create_table_comments(file)
    create_table_rates(file)
    create_table_contracts(file)
  end

  # метод заполнения всех таблиц
  def insert_into
    insert_into_clients
    insert_into_banned_clients
    insert_into_speech_therapists
    insert_into_services
    insert_into_comments
    insert_into_rates
    insert_into_contracts
  end

  # метод создания таблицы клиентов
  def create_table_clients(file)
    file.puts("DROP TABLE IF EXISTS clients CASCADE;\n" \
              "CREATE TABLE clients (\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tsurname varchar(23) NOT NULL,\n" \
              "\tfirst_name varchar(23) NOT NULL,\n" \
              "\tpatronymic varchar(23) NOT NULL,\n" \
              "\tphone varchar(11) NOT NULL,\n" \
              "\tpassport_series varchar(4) NOT NULL,\n" \
              "\tpassport_number varchar(6) NOT NULL,\n" \
              "\tbirthday date NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы заблокированных пользователей
  def create_table_banned_clients(file)
    file.puts("DROP TABLE IF EXISTS banned_clients;\n" \
              "CREATE TABLE banned_clients(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\treason text NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы логопедов
  def create_table_speech_therapists(file)
    file.puts("DROP TABLE IF EXISTS speech_therapists CASCADE;\n" \
              "CREATE TABLE speech_therapists(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы услуг логопедов
  def create_table_services(file)
    file.puts("DROP TABLE IF EXISTS services CASCADE;\n" \
              "CREATE TABLE services(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tprice_per_hour integer NOT NULL,\n" \
              "\tdescription text NOT NULL,\n" \
              "\tspeech_therapist_id integer REFERENCES speech_therapists (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы комментариев пользователей
  def create_table_comments(file)
    file.puts("DROP TABLE IF EXISTS comments;\n" \
              "CREATE TABLE comments(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tbody text NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL,\n" \
              "\tspeech_therapist_id integer REFERENCES speech_therapists (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы оценок логопедам
  def create_table_rates(file)
    file.puts("DROP TABLE IF EXISTS rates;\n" \
              "CREATE TABLE rates(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tcount integer NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL,\n" \
              "\tspeech_therapist_id integer REFERENCES speech_therapists (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы договоров
  def create_table_contracts(file)
    file.puts("DROP TABLE IF EXISTS contracts;\n" \
              "CREATE TABLE contracts(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\thours integer NOT NULL,\n" \
              "\ttotal_cost integer NOT NULL,\n" \
              "\tissue_date date NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL,\n" \
              "\tservice_id integer REFERENCES services (id) NOT NULL\n" \
              ");\n")
  end

  # метод для заполнения таблицы клиентов
  def insert_into_clients
    names = parse_names

    File.open('clients_data.sql', 'w') do |file|
      file.puts('INSERT INTO clients (surname, first_name, patronymic, phone, ' \
        'passport_series, passport_number, birthday) VALUES')

      39_999.times do |n|
        file.puts("\t('#{names[n][0]}', '#{names[n][1]}', '#{names[n][2]}', '#{random_phone}', " \
          "'#{random_passport_series}', '#{random_passport_number}', '#{random_birthday}'),")
      end

      file.puts("\t('#{names[-1][0]}', '#{names[-1][1]}', '#{names[-1][2]}', '#{random_phone}', " \
         "'#{random_passport_series}', '#{random_passport_number}', '#{random_birthday}');")
    end
  end

  # метод для заполнения таблицы заблокированных пользователей
  def insert_into_banned_clients
    File.open('banned_clients_data.sql', 'w') do |file|
      file.puts('INSERT INTO banned_clients (reason, client_id) VALUES')
      99.times { file.puts("\t('#{Faker::Lorem.paragraph}', #{rand(1..40_000)}),") }
      file.puts("\t('#{Faker::Lorem.paragraph}', #{rand(1..40_000)});")
    end
  end

  # метод для заполнения таблицы логопедов
  def insert_into_speech_therapists
    File.open('speech_therapists_data.sql', 'w') do |file|
      file.puts('INSERT INTO speech_therapists (client_id) VALUES')
      4999.times { file.puts("\t(#{rand(1..40_000)}),") }
      file.puts("\t(#{rand(1..40_000)});")
    end
  end

  # метод для заполнения таблицы услуг логопедов
  def insert_into_services
    File.open('services_data.sql', 'w') do |file|
      file.puts('INSERT INTO services (price_per_hour, description, speech_therapist_id) VALUES')
      49_999.times { file.puts("\t(#{rand(1..10) * 1000}, '#{Faker::Lorem.paragraph}', #{rand(1..5000)}),") }
      file.puts("\t(#{rand(1..10) * 1000}, '#{Faker::Lorem.paragraph}', #{rand(1..5000)});")
    end
  end

  # метод для заполнения таблицы комментариев
  def insert_into_comments
    File.open('comments_data.sql', 'w') do |file|
      file.puts('INSERT INTO comments (body, client_id, speech_therapist_id) VALUES')
      99_999.times { file.puts("\t('#{Faker::Lorem.paragraph}', #{rand(1..40_000)}, #{rand(1..5000)}),") }
      file.puts("\t('#{Faker::Lorem.paragraph}', #{rand(1..40_000)}, #{rand(1..5000)});")
    end
  end

  # метод для заполнения таблицы оценок
  def insert_into_rates
    File.open('rates_data.sql', 'w') do |file|
      file.puts('INSERT INTO rates (count, client_id, speech_therapist_id) VALUES')
      99_999.times { file.puts("\t(#{rand(1..5)}, #{rand(1..40_000)}, #{rand(1..5000)}),") }
      file.puts("\t(#{rand(1..5)}, #{rand(1..40_000)}, #{rand(1..5000)});")
    end
  end

  # метод для заполения таблицы договоров
  def insert_into_contracts
    File.open('contracts_data.sql', 'w') do |file|
      file.puts('INSERT INTO contracts (hours, total_cost, issue_date, client_id, service_id) VALUES')
      4_999_999.times do
        file.puts("\t(#{rand(1..20)}, #{rand(1..20) * 1000}, '#{random_issue_date}', " \
                  "#{rand(1..40_000)}, #{rand(1..50_000)}),")
      end
      file.puts("\t(#{rand(1..20)}, #{rand(1..20) * 1000}, '#{random_issue_date}', " \
                "#{rand(1..40_000)}, #{rand(1..50_000)});")
    end
  end

  # хуйня не получилоась
  # def file_creating(file_name, query_header, query_value, count)
  #   File.open(file_name, 'w') do |file|
  #     file.puts("INSERT INTO #{query_header} VALUES")
  #     count-1.times { |n| file.puts("\t(#{query_value}),") }
  #     file.puts("\t(#{query_value})")
  #   end
  # end

  # получение всех имен из файлов
  def parse_names
    File.open('names.txt', 'r:UTF-8').readlines.collect(&:split)
  end

  # случайный номер российского телефона (мск)
  def random_phone
    random_int_str = rand(1..999_999_999).to_s
    "89#{'0' * (9 - random_int_str.length)}#{random_int_str}"
  end

  # случайная серия российского паспорта
  def random_passport_series
    rand(1000..9999).to_s
  end

  # случайный номер российского паспорта
  def random_passport_number
    random_int_str = rand(1..999_999).to_s
    "#{'0' * (6 - random_int_str.length)}#{random_int_str}"
  end

  # случайная дата рождения
  def random_birthday
    Faker::Date.between(from: '1953-03-05', to: '2013-03-05')
  end

  # случайная дата заключения договора
  def random_issue_date
    Faker::Date.between(from: '2020-01-01', to: '2023-02-06')
  end
end
