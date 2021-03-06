﻿Процедура УстановитьИдентификаторЧата(Логин, ИдЧата) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Телеграм_Логин = &Логин
		|	И Сотрудники.Телеграм_ИдЧата = 0
		|	И НЕ Сотрудники.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Логин", Логин);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл

		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Телеграм_ИдЧата = ИдЧата;
		
		СправочникОбъект.Записать();
		
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьСотрудникаПоЛогинуТелеграм(Логин) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Телеграм_Логин = &Телеграм_Логин
		|	И НЕ Сотрудники.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Телеграм_Логин", Логин);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		Возврат Выборка.Ссылка;	
	
	КонецЕсли;
	
КонецФункции // ПолучитьСотрудникаПоЛогинуТелеграм()

Функция ПолучитьДанныеСотрудников(ПараметрыЗапроса) Экспорт

	Сотрудники = Новый Массив;
	ИДСотрудников = СтрРазделить(ПараметрыЗапроса.Сотрудники, ";");
	
	Для каждого ИдентификаторСотрудника Из ИДСотрудников Цикл
	
		Сотрудники.Добавить(ОбщегоНазначения.ПолучитьСсылкуПоУИД("Сотрудники", ИдентификаторСотрудника));
	
	КонецЦикла;

	ДанныеСотрудников = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка,
		|	Сотрудники.Код КАК Код,
		|	Сотрудники.Наименование КАК Наименование,
		|	Сотрудники.РольСотрудника КАК РольСотрудника,
		|	Сотрудники.НомерТелефона КАК НомерТелефона
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	НЕ Сотрудники.ПометкаУдаления
		|	И Сотрудники.Ссылка В(&Сотрудники)";
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураДанных = Новый Структура("Код, Наименование, НомерТелефона");
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Выборка);
		
		СтруктураДанных.Вставить("Ссылка", Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		СтруктураДанных.Вставить("РольСотрудника", XMLСтрока(Выборка.РольСотрудника));
		
		ДанныеСотрудников.Добавить(СтруктураДанных);
		
	КонецЦикла;
	
	Возврат ДанныеСотрудников;
	
КонецФункции // ПолучитьДанныеСотрудников()

Функция СоздатьСотрудника(ПараметрыЗапроса) Экспорт

	Ссылка = ОбщегоНазначения.ПолучитьСсылкуПоУИД("Сотрудники", ПараметрыЗапроса.Ссылка);

	Если ЗначениеЗаполнено(Ссылка.ВерсияДанных) Тогда
		Возврат Ссылка;
	КонецЕсли;
	
	СправочникОбъект = Справочники.Сотрудники.СоздатьЭлемент();
	СправочникОбъект.УстановитьСсылкуНового(Ссылка);
	
	ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыЗапроса);
	
	Если НЕ ЗначениеЗаполнено(СправочникОбъект.РольСотрудника) Тогда
		СправочникОбъект.РольСотрудника = Перечисления.РолиСотрудников[ПараметрыЗапроса.РольСотрудника];
	КонецЕсли;
	
	СправочникОбъект.ОбменДанными.Загрузка = Истина;
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;

КонецФункции // СоздатьСотрудника()
