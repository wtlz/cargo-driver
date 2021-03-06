﻿Функция НаличиеСвойстваУОбъекта(Объект, ИмяСвойства) Экспорт

	ИдентификаторОтсутствия = Новый УникальныйИдентификатор;
	Структура = Новый Структура(ИмяСвойства, ИдентификаторОтсутствия);
	
	ЗаполнитьЗначенияСвойств(Структура, Объект);
	
	Возврат Структура[ИмяСвойства] <> ИдентификаторОтсутствия;

КонецФункции

Функция ПолучитьСсылкуПоУИД(ИмяСправочника, Ссылка) Экспорт
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор(Ссылка);
	Возврат Справочники[ИмяСправочника].ПолучитьСсылку(УникальныйИдентификатор);
	
КонецФункции

Функция СоответствиеВСтруктуру(Соответствие) Экспорт

	ПараметрыСообщения = Новый Структура;
	
	Для каждого КлючИЗначение Из Соответствие Цикл
		ПараметрыСообщения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;

	Возврат ПараметрыСообщения;
	
КонецФункции // ()

