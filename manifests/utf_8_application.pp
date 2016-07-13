application utf_8::utf_8_application (
  $message = $name
) {
  utf_8::component_one { "${name}_first":
    message => $message,
    #export  => Blank["exported_${message}"],
  }

  utf_8::component_one { "${name}_second":
    message => $message,
    #require => Blank["exported_${message}"],
  }
}
