#!/usr/bin/env bats

for program in "wget telnet"; do
  if ! command -V $program &>/dev/null; then
    echo "The program '$program' is not installed. Install it and rerun the test" >&2
    exit 1
  fi
done

if ! command -v shyaml &>/dev/null; then
  echo "They 'shyaml' program is not installed. Install it with 'pip install shyaml'."
  exit 1
fi

if  [ "${honeypots:-unset}" == "unset" ]; then
  echo "Missing environment variable 'honeypots' that contains the honeypot specification." >&2
  exit 1
fi

@test "Ping honeypots" {
  grep -Eo "^[\s]{2}[a-zA-Z][a-zA-Z0-9-]*" <<< $honeypots >&3
  for honeypot in $(grep -Eo "^[a-zA-Z][a-zA-Z0-9-]*" <<< $honeypots); do
    if ip=$(grep -Eo "\([0-9.]{1,3}\){4}$" <<< $honeypot); then
      run ping -c1 $ip
      [ $status -ne 0 ] && pass "ASSDADS" >&3
    fi
  done
}
