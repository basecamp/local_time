class LocalTime.CalendarDate
  @fromDate: (date) ->
    new this date.getFullYear(), date.getMonth() + 1, date.getDate()

  @today: ->
    @fromDate new Date

  constructor: (year, month, day) ->
    @date = new Date Date.UTC year, month - 1
    @date.setUTCDate day

    @year = @date.getUTCFullYear()
    @month = @date.getUTCMonth() + 1
    @day = @date.getUTCDate()
    @value = @date.getTime()

  equals: (calendarDate) ->
    calendarDate?.value is @value

  is: (calendarDate) ->
    @equals calendarDate

  isToday: ->
    @is @constructor.today()

  occursOnSameYearAs: (date) ->
    @year is date?.year

  occursThisYear: ->
    @occursOnSameYearAs @constructor.today()

  daysSince: (date) ->
    if date
      (@date - date.date) / (1000 * 60 * 60 * 24)

  daysPassed: ->
    @constructor.today().daysSince @
