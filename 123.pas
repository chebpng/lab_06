program LinkedListExample;

type
  pel = ^elem;
  elem = record
    Surname: string;
    Country: string;
    Registration: string;
    p: pel; // указатель на следующий элемент списка
  end;

var
  p1, p2, p3: pel; // указатели для работы со списком
  f: TextFile;
  line: string;
  
  Procedure ClearMem();
  begin
    while p1 <> nil do
    begin
      p3 := p1; // Временный указатель на текущий элемент
      p1 := p1^.p; // Переход к следующему элементу
      Dispose(p3); // Освобождаем память текущего элемента
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
    p3^.Surname := Copy(line, 1, Pos(' ', line) - 1);
    Delete(line, 1, Pos(' ', line)); // Удаляем фамилию из строки

    p3^.Country := Copy(line, 1, Pos(' ', line) - 1);
    Delete(line, 1, Pos(' ', line)); // Удаляем страну из строки

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

  // Вывод данных из списка
  p3 := p1; // Устанавливаем указатель на начало списка
  while p3 <> nil do
  begin
    WriteLn('Фамилия: ', p3^.Surname,'    Страна: ', p3^.Country,'    Регистрация: ', p3^.Registration);
    p3 := p3^.p; // Переходим к следующему элементу
  end;

  ClearMem();

end.
