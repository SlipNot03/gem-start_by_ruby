# lib/start_by_ruby/generator.rb
require 'fileutils' # Подключаем стандартный модуль Ruby для работы с файлами

module StartByRuby
  class Generator
    # --- Константы для удобства ---
    
    # Определяем абсолютный путь к нашим шаблонам.
    # `__dir__` -> "/path/to/gem/lib/start_by_ruby"
    # `File.expand_path('../../templates', __dir__)` -> "/path/to/gem/templates"
    # Это надежный способ найти шаблоны, где бы гем ни был установлен.
    TEMPLATES_DIR = File.expand_path('../../templates', __dir__)

    # Хэш-карта для удобного сопоставления "шаблон -> целевой файл"
    FILES_TO_CREATE = { "Gemfile.tt" => "Gemfile","Rakefile.tt" => "Rakefile","db_config.rb.tt" => "config/db_config.rb",
    "main.rb.tt" => "main.rb","delete_this.tt" => "db/migrations/delete_this.rb","delete_this_too.tt" => "db/models/delete_this_too.rb" }

    # --- Публичные методы ---

    # Класс-метод для удобного вызова: StartByRuby::Generator.run
    def self.run
      new.run
    end

    # Основной метод экземпляра, который выполняет всю работу
    def run
      puts "Starting project setup..."
      FILES_TO_CREATE.each do |template, destination|
        create_file_from_template(template, destination)
      end
      puts "Done!"
    end

    # --- Приватные методы (вспомогательная логика) ---
    private

    def create_file_from_template(template_name, destination_path)
      # Полный путь к исходному файлу-шаблону
      source = File.join(TEMPLATES_DIR, template_name)
      
      # Полный путь к целевому файлу.
      # `Dir.pwd` (Print Working Directory) — это ключевой момент!
      # Он возвращает директорию, ИЗ КОТОРОЙ пользователь запустил команду.
      destination = File.join(Dir.pwd, destination_path)

      # Защита от перезаписи существующих файлов
      if File.exist?(destination)
        puts "Skipping: #{destination_path} already exists."
        return # Выходим из метода для этого файла
      end
      
      # Создаем родительскую папку (например, `config/`), если ее нет.
      # `mkdir_p` не выдаст ошибку, если папка уже существует.
      FileUtils.mkdir_p(File.dirname(destination))

      # Основное действие: копирование файла
      FileUtils.copy_file(source, destination)
      puts "Created: #{destination_path}"
    end
  end
end