setup() {
  load '../../test_helper/bats-support/load'
  load '../../test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
}


@test "Can process underline" {
  TFILE="${DIR}/inline001.in"
  TRESULT='\underbar{underlined text}'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process superscript" {
  TFILE="${DIR}/inline002.in"
  TRESULT='x$^{2}$'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process subscript" {
  TFILE="${DIR}/inline003.in"
  TRESULT='H$_{2}$O'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process small caps" {
  TFILE="${DIR}/inline004.in"
  TRESULT='{\caps  Small Caps}'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process double-quoted text" {
  TFILE="${DIR}/inline005.in"
  TRESULT="\`\`hello world''"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process single-quoted text" {
  TFILE="${DIR}/inline006.in"
  TRESULT="This is \`single' quoted."
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process inline math" {
  TFILE="${DIR}/inline007.in"
  TRESULT='inline math: $x^2$'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process display math" {
  TFILE="${DIR}/inline008.in"
  TRESULT='$$\sum_{i=1}^n i$$'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}

@test "Can process span (passes through content)" {
  TFILE="${DIR}/inline009.in"
  TRESULT='some highlighted text'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/inline_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/inline_tests_tmp"
  assert_success
}
