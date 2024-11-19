{$codepage UTF8}
program mass;

uses SysUtils;

type
  pel = ^elem;
  elem = record
    Surname: string;
    Country: string;
    Registration: string;
    Naprav:string;
    Year:string;
    p: pel; // указатель на следующий элемент списка
  end;

var
  p1, p2, p3: pel; // указатели для работы со списком
  f: TextFile;
  line,temp: string;


// Процедура очистки памяти
procedure ClearMem();
begin
  while p1 <> nil do
  begin
    p3 := p1; // Временный указатель на текущий элемент
    p1 := p1^.p; // Переход к следующему элементу
    Dispose(p3); // Освобождаем память текущего элемента
  end;
end;


procedure VivSp();
begin

  // Вывод заголовка таблицы
  WriteLn(Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
    ['Фамилия', 'Страна', 'Регистрация', 'Направление', 'Год рождения']));
  WriteLn(StringOfChar('-', 85));

  p3 := p1; // Устанавливаем указатель на начало списка
  while p3 <> nil do
  begin
    // Вывод строки с данными, отформатированными по ширине
    WriteLn(Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
      [p3^.Surname, p3^.Country, p3^.Registration, p3^.Naprav, p3^.Year]));
    p3 := p3^.p; // Переходим к следующему элементу
  end;
  WriteLn(StringOfChar('-', 85));
  ReadLn();
end;


// Функция извлечения первого слова из строки
function ExtractWord(var s: string): string;
var
  posSpace: Integer;
begin
  s := Trim(s); // Убираем лишние пробелы
  posSpace := Pos(' ', s); // Находим первый пробел
  if posSpace > 0 then
  begin
    Result := Copy(s, 1, posSpace - 1); // Первое слово
    Delete(s, 1, posSpace); // Удаляем слово из строки
    s := Trim(s); // Убираем лишние пробелы
  end
  else
  begin
    Result := s; // Если больше нет пробелов, возвращаем остаток строки
    s := ''; // Очищаем строку
  end;
end;


begin
  AssignFile(f, 'file1.txt'); // Укажите имя файла
  Reset(f); // Открываем файл на чтение

  p1 := nil; // Начало списка
  p2 := nil; // Текущий хвост списка

  // Читаем файл построчно
  while not EOF(f) do
  begin
    New(p3); // Создаём новую запись
    ReadLn(f, line); // Читаем строку из файла

    // Разбираем строку и извлекаем данные
    p3^.Surname := ExtractWord(line); // Извлекаем фамилию
    p3^.Country := ExtractWord(line); // Извлекаем страну
    p3^.Registration := line; // Оставшееся — место регистрации
    p3^.p := nil; // Последний элемент указывает на nil

    // Добавляем элемент в список
    if p1 = nil then
      p1 := p3 // Если это первый элемент списка
    else
      p2^.p := p3; // Привязываем новый элемент к последнему

    p2 := p3; // Обновляем хвост списка
  end;
  CloseFile(f); // Закрываем файл
  AssignFile(f, 'file4.txt');
  Reset(f);
  while not EOF(f) do
  begin
       ReadLn(f, line);
       temp:=ExtractWord(line);
       p3 := p1;
       while (p3 <> nil) and (temp <> p3^.Surname) do
       begin
           p3:=p3^.p;
       end;
        if p3 <> nil then
        begin
          p3^.Naprav := ExtractWord(line);
          p3^.Year := ExtractWord(line);
        end;
  end;
  VivSp();
  ClearMem(); // Очистка памяти
  end.





