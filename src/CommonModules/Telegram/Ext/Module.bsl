﻿#Если Не МобильноеПриложениеСервер Тогда
	
Процедура ОтправитьСообщение(ИдЧата, ТекстСообщения, СообщениеСсылка) Экспорт

    НастройкиПодключения = ПолучитьНастройкиПодключения();
	
	ИмяМетода = "sendMessage";
	
	Ресурс = "bot" + НастройкиПодключения.Токен + "/" + ИмяМетода + 
		"?" + "chat_id=" + Формат(ИдЧата, "ЧГ=") + "&text=" + ТекстСообщения;
	
	Ответ = КоннекторHTTP.Post(НастройкиПодключения.Сервер + Ресурс);
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	ВыполненоУспешно = Результат.Получить("ok");
	
	Если ВыполненоУспешно Тогда
		
		// TODO записать в лог отправленных tg-сообщений
		
	Иначе
		
		Ошибка = Результат.Получить("description");
		ЗаписьЖурналаРегистрации("Telegram." + ИмяМетода, УровеньЖурналаРегистрации.Ошибка, , СообщениеСсылка, Ошибка); 
		
	КонецЕсли;

КонецПроцедуры

Процедура ПолучитьНовыеСообщения() Экспорт
	
    НастройкиПодключения = ПолучитьНастройкиПодключения();
	
	ИмяМетода = "getUpdates";
	Ресурс = "bot" + НастройкиПодключения.Токен + "/" + ИмяМетода;
	
	Ответ = КоннекторHTTP.Get(НастройкиПодключения.Сервер + Ресурс);
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	ВыполненоУспешно = Результат.Получить("ok");
	
	Если ВыполненоУспешно Тогда
		
		ПолученныеСообщения = Результат.Получить("result");
		ОбработатьПолученныеСообщения(ПолученныеСообщения);
		
	Иначе
		
		Ошибка = Результат.Получить("description");
		ЗаписьЖурналаРегистрации("Telegram." + ИмяМетода, УровеньЖурналаРегистрации.Ошибка, , , Ошибка); 
	
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНастройкиПодключения()
	
	НастройкиПодключения = Новый Структура;
	НастройкиПодключения.Вставить("Сервер", "api.telegram.org/");
	НастройкиПодключения.Вставить("Токен", Константы.Телеграм_Токен.Получить());

	Возврат НастройкиПодключения;
	
КонецФункции

Процедура ОбработатьПолученныеСообщения(ПолученныеСообщения)

	Для каждого КореньСообщения Из ПолученныеСообщения Цикл
		
		Попытка
			ОбработатьПолученноеСообщение(КореньСообщения);
		Исключение
			ЗаписьЖурналаРегистрации("Telegram.ПолучениеСообщения", УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;

КонецПроцедуры

Процедура ОбработатьПолученноеСообщение(Знач КореньСообщения)
	
	СмещениеЧасовогоПояса = ТекущаяДатаСеанса() - ТекущаяУниверсальнаяДата();
	
	ТелоСообщения = КореньСообщения.Получить("message");
	
	СтруктураОт = ТелоСообщения.Получить("from");
	ТекстСообщения = ТелоСообщения.Получить("text");
	
	Логин	= СтруктураОт.Получить("username");
	ИдЧата	= СтруктураОт.Получить("id");
	ДатаСоздания	= '19700101' + ТелоСообщения.Получить("date") + СмещениеЧасовогоПояса;
	ИдСообщения		= КореньСообщения.Получить("update_id");
	
	Если ТекстСообщения = "/start" Тогда
		
		Справочники.Сотрудники.УстановитьИдентификаторЧата(Логин, ИдЧата);
		
	Иначе
		
		ЗаписатьНовоеСообщение(ДатаСоздания, Логин, ТекстСообщения, ИдСообщения);
		
	КонецЕсли;

КонецПроцедуры

Процедура ЗаписатьНовоеСообщение(Знач ДатаСоздания, Знач Логин, Знач ТекстСообщения, ИдСообщения)
	
	Если Справочники.СообщенияЧата.СообщениеПринято(ИдСообщения) Тогда
		Возврат;	
	КонецЕсли;
	
	ПараметрыСообщения = ПолучитьПараметрыСообщения(Логин, ТекстСообщения, ДатаСоздания, ИдСообщения);
	Сообщение = Справочники.СообщенияЧата.СоздатьСообщение(ПараметрыСообщения);

	РегистрыСведений.СтатусыСообщений.СоздатьЗаписьСтатусСообщения(Сообщение, Перечисления.СтатусыСообщений.Отправлено);
	
КонецПроцедуры

Функция ПолучитьПараметрыСообщения(Логин, ТекстСообщения, ДатаСоздания, ИдСообщения)

	ПараметрыСообщения = Новый Структура;
	
	ПараметрыСообщения.Вставить("Автор", Справочники.Сотрудники.ПолучитьСотрудникаПоЛогинуТелеграм(Логин));
	
	Если НЕ ЗначениеЗаполнено(ПараметрыСообщения.Автор) Тогда
	
		ВызватьИсключение "Не найден пользователь по логину " + Логин;
	
	КонецЕсли;
	
	ПараметрыСообщения.Вставить("Ссылка", 				Строка(Новый УникальныйИдентификатор()));
	ПараметрыСообщения.Вставить("КаналЧата",			ПараметрыСообщения.Автор.РольСотрудника);
	ПараметрыСообщения.Вставить("ТекстСообщения",		ТекстСообщения);
	ПараметрыСообщения.Вставить("ДатаСоздания",			ДатаСоздания);
	ПараметрыСообщения.Вставить("Телеграм_ИдСообщения",	ИдСообщения);
	
	// TODO - предусмотреть закрепление одного сотрудника к нескольким транспортным средствам.
	ЗакрепленныйСотрудник = РегистрыСведений.ЗакрепленныеСотрудники.ПолучитьТранспортноеСредствоСотрудника(ПараметрыСообщения.Автор);
	ПараметрыСообщения.Вставить("ТранспортноеСредство",	ЗакрепленныйСотрудник);
	
	Возврат ПараметрыСообщения;
	
КонецФункции // ()

#КонецЕсли