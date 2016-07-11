define utf_8::component_one (
  $message = 'english',
) {
  notify { $message: }
}

Utf_8::Component_one produces Blank {
  message => $message,
}
