﻿Процедура СоздатьЗаписьСтатусСообщения(Сообщение, Статус) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СтатусыСообщений.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Сообщение = Сообщение;
	МенеджерЗаписи.Статус = Статус;
	МенеджерЗаписи.Записать();

КонецПроцедуры
