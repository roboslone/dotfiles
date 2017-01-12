stylingOptions =
    background: 'rgba(#fff, 0.0)'
    color: 'rgba(255, 255, 255, 1.0)'
    font: 'Helvetica Neue'
    fullscreen: true
    vertical: 'top'  # display position 'top', 'middle', 'bottom'

dateOptions =
    # display not only 'time' also 'date'
    showDate: false
    # format of 'date'
    date: '%d/%m/%Y %a'

format = (->
    if dateOptions.showDate
      dateOptions.date + '\n' +'%H:%M'
    else
      '%H:%M'
)()

command: "date +\"#{format}\""

# the refresh frequency in milliseconds
refreshFrequency: 30000

# for update function
dateOptions: dateOptions

render: (output) -> """
    <div id='simpleClock'>#{output}</div>
"""

update: (output) ->
    if this.dateOptions.showDate
        data = output.split('\n')
        html = data[1]
        html += '<span class="date">'
        html += data[0]
        html += '</span>'
    else
        html = output

    $(simpleClock).html(html)

style: (->
    fontSize = '8em'
    width = 'auto'
    transform = 'auto'
    bottom = '0%'
    top = 'auto'

    if stylingOptions.fullscreen
        fontSize = '14em'
        width = '100%'

    if stylingOptions.vertical is 'middle'
        transform = 'translateY(50%)'
        bottom = '50%'
    else if stylingOptions.vertical is 'top'
        bottom = 'auto'
        top = '27%'

    return """
        background: #{stylingOptions.background}
        color: #{stylingOptions.color}
        font-family: #{stylingOptions.font}
        text-shadow: 0px 0px 0px rgba(255, 255, 255, 0.7)
        top: #{top}
        bottom: #{bottom}
        transform: #{transform}
        width: #{width}

        #simpleClock
            font-size: #{fontSize}
            font-weight: 100
            margin: 0
            text-align: center
            padding: 10px 20px

        #simpleClock .date
            margin-left: .5em
            font-size: .5em
    """
)()
