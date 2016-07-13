define utf_8::component_one (
  $message = 'english',
) {
  notify { $message: }
}

Utf_8::Component_one produces Sql {
  # name     => 'dylandb',
  user     => 'dylan',
  password => 'hunter2',
  host     => $::fqdn,
  port     => '1234',
  database => 'dylandb',
  type     => 'postgresql',
}
