setup() {
  load '../../test_helper/bats-support/load'
  load '../../test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
}


@test "Can process level one (chapter) header" {
  TFILE="${DIR}/header001.in"
  TRESULT="\chap  This is a level one header"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
}

@test "Can process level two (section) header" {
  TFILE="${DIR}/header002.in"
  TRESULT="\sec  This is a level two header"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
}



@test "Can process level three (subsection) header" {
  TFILE="${DIR}/header003.in"
  TRESULT="\secc  This is a level three header"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
}



@test "Can process level four (sub-subsection) header" {
  TFILE="${DIR}/header004.in"
  TRESULT="\seccc  This is a level four header"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
}

@test "Can process header level above four ( >= 5..10 )" {
  for LVL in {5..10}
  do
    TRESULT="\secl${LVL} This is a level ${LVL} header"
    TINPUT=""
    for ((i=0; i<LVL; i++))
    do
      TINPUT="${TINPUT}#"
    done
    TINPUT="${TINPUT} This is a level ${LVL} header"
    run pandoc -d optex -f markdown <<<"$TINPUT"
    assert_success
    assert_output "$TRESULT"
    run pandoc -d optex-standalone -f markdown <<<"$TINPUT"
    assert_success
    assert_output --partial "$TRESULT"

  done
}


teardown() {
  rm -rf "${DIR}mptestfile"
}
