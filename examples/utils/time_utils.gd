class_name TimeUtils

extends RefCounted

static var time_string_template: String = "{minutes}:{seconds}:{milliseconds}"

static func convert_ms_to_time(time_ms: int) -> String:
    var minutes = time_ms / 60000  # Convert milliseconds to minutes
    var seconds = (time_ms / 1000) % 60  # Convert milliseconds to seconds and get remainder after 60 seconds
    var milliseconds = time_ms % 1000  # Get the remainder in milliseconds

    # Format the template string with padded values
    var formatted_text = time_string_template.format({
        "minutes": str(minutes),
        "seconds": str(seconds).pad_zeros(2),
        "milliseconds": str(milliseconds).pad_zeros(3)
    })
    
    return formatted_text
