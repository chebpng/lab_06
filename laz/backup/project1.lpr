//вывод в файл, оценить трудоемкость
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
  p1, p2, p3,p4: pel; // указатели для работы со списком
  f, o: TextFile;
  line,temp: string;
  tempor : ^elem;
  SeenRegistrations: array of AnsiString; // Динамический массив для хранения уникальных значений
  Found, flag: Boolean; // Флаг для проверки, найдено ли значение в массиве
  i: Integer;



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
  WriteLn(o,Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
    ['Фамилия', 'Страна', 'Регистрация', 'Направление', 'Год рождения']));
  WriteLn(StringOfChar('-', 85));
  WriteLn(o,StringOfChar('-', 85));

  p3 := p1; // Устанавливаем указатель на начало списка
  while p3 <> nil do
  begin
    // Вывод строки с данными, отформатированными по ширине
    WriteLn(Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
      [p3^.Surname, p3^.Country, p3^.Registration, p3^.Naprav, p3^.Year]));
    WriteLn(o,Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
      [p3^.Surname, p3^.Country, p3^.Registration, p3^.Naprav, p3^.Year]));
    p3 := p3^.p; // Переходим к следующему элементу
  end;
  WriteLn(StringOfChar('-', 85));
  WriteLn(o, StringOfChar('-', 85));
end;


procedure VivSpNeRu();
begin

  // Вывод заголовка таблицы
  WriteLn(Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
    ['Фамилия', 'Страна', 'Регистрация', 'Направление', 'Год рождения']));
  WriteLn(StringOfChar('-', 85));
    WriteLn(o,Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
    ['Фамилия', 'Страна', 'Регистрация', 'Направление', 'Год рождения']));
  WriteLn(o,StringOfChar('-', 85));

  p3 := p1; // Устанавливаем указатель на начало списка
  while p3 <> nil do
  if p3^.Country<>AnsiString('Россия')then
  begin
    // Вывод строки с данными, отформатированными по ширине
    WriteLn(Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
      [p3^.Surname, p3^.Country, p3^.Registration, p3^.Naprav, p3^.Year]));
        WriteLn(o,Format('%-15s|%-15s|%-20s|%-15s|%-15s|',
      [p3^.Surname, p3^.Country, p3^.Registration, p3^.Naprav, p3^.Year]));
    p3 := p3^.p; // Переходим к следующему элементу
  end
  else
    p3:=p3^.p;
  WriteLn(StringOfChar('-', 85));
  WriteLn(o,StringOfChar('-', 85));

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
  AssignFile(o, 'vivod.txt');
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

    AssignFile(f, 'file2.txt'); // Укажите имя файла
  Reset(f); // Открываем файл на чтение


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

  AssignFile(f, 'file3.txt');
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

  flag := false; // Инициализация флага
  p2 := p1; // p2 указывает на начало списка
  p3 := p1^.p; // p3 указывает на следующий элемент

 while not flag do
begin
  flag := True; // Считаем, что список отсортирован
  p2 := nil;    // Указатель на предыдущий элемент
  p3 := p1;     // Указатель на текущий элемент

  while p3^.p <> nil do
  begin
    if p3^.Year > p3^.p^.Year then
    begin
      // Меняем местами узлы p3 и p3^.p
      if p2 = nil then
      begin
        // Если p3 — первый элемент списка
        p1 := p3^.p;       // Начало списка теперь p3^.p
      end
      else
      begin
        // Связываем предыдущий элемент с p3^.p
        p2^.p := p3^.p;
      end;

      // Перестановка ссылок
      tempor := p3^.p;          // Временная ссылка на следующий элемент
      p3^.p := tempor^.p;       // p3 теперь указывает на узел после tempor
      tempor^.p := p3;          // tempor указывает на p3

      // Если был обмен, устанавливаем флаг
      flag := False;

      // Обновляем указатель p2
      if p2 = nil then
        p2 := p1
      else
        p2 := tempor;          // prev теперь указывает на новый узел перед p3
    end
    else
    begin
      // Если обмена не было, переходим к следующей паре элементов
      p2 := p3;
      p3 := p3^.p;
    end;
  end;
end;
VivSp();
writeln();
writeln('Для вывода списков субъектов РФ  из которых прибыли на учебу студенты обоих направлений нажмите enter');
ReadLn();
SetLength(SeenRegistrations, 0); // Изначально массив пустой
  p2 := p1;
  p3 := p1;
  writeln();

  while p3^.p <> nil do
  begin
    if p3^.Country = AnsiString('Россия') then
    begin
      // Проверяем, есть ли Registration в массиве SeenRegistrations
      Found := False;
      for i := 0 to High(SeenRegistrations) do
      begin
        if SeenRegistrations[i] = p3^.Registration then
        begin
          Found := True;
          Break;
        end;
      end;

      // Если не найдено, добавляем в массив и выводим
      if not Found then
      begin
        SetLength(SeenRegistrations, Length(SeenRegistrations) + 1);
        SeenRegistrations[High(SeenRegistrations)] := p3^.Registration;
        writeln(p3^.Registration);
        writeln(o, p3^.Registration);
      end;
    end;
    p3 := p3^.p;
  end;
writeln();
writeln('Для формирования таблицы с информацией о зарубежных студентах нажмите enter');
readln();
writeln();
writeln();
VivSpNeRu();
readln();

  ClearMem();
  close(o);
  end.
