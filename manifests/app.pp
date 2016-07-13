application utf_8::app (
  $message = $name
) {
  utf_8::component_one { "${name}_first":
    message => $message,
    export  => Sql["exported_${message}"],
  }

  utf_8::component_one { "${name}_second":
    message => $message,
    require => Sql["exported_${message}"],
  }
}
