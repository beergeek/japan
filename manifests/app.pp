application utf_8::app (
  $message = $name
) {
  utf_8::component_one { "${name}_first":
    message => $message,
    export  => Blank["exported_${message}"],
  }

  utf_8::component_one { "${name}_second":
    consume => Blank["exported_${message}"],
  }
}
