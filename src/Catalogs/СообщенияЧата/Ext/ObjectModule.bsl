﻿Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;

КонецПроцедуры
