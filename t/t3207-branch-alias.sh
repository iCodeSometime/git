#!/bin/sh
#
# Copyright (c) 2019 Kenneth Cochran
#

test_description='git branch assorted tests'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-rebase.sh

test_expect_success 'prepare a trivial repository' '
	echo Hello >A &&
	git update-index --add A &&
	git commit -m "Initial commit." &&
	echo World >>A &&
	git update-index --add A &&
	git commit -m "Second commit." &&
	HEAD=$(git rev-parse --verify HEAD)
'

test_expect_success 'git branch --alias' '
	test_must_fail git branch --alias
'

test_expect_success 'git branch --alias sym' '
	echo "sym created as an alias for master" >expect &&
	git branch --alias sym >actual &&
	test_i18ncmp expect actual &&
	echo $HEAD >expect &&
	git rev-parse --verify sym >actual &&
	test_i18ncmp expect actual
'

test_expect_success 'git branch --alias sym1 brnch' '
	git branch brnch &&
	echo "sym1 created as an alias for brnch" >expect &&
	git branch --alias sym1 brnch >actual &&
	test_i18ncmp expect actual &&
	git rev-parse --verify brnch >expect &&
	git rev-parse --verify sym1 >actual &&
	test_i18ncmp expect actual
'

test_expect_success 'git branch --alias sym2 brnch2 third_arg' '
	test_must_fail git branch --alias sym2 brnch2 third_arg
'

test_expect_success 'git branch --alias refuses to overwrite existing branch' '
	git branch bre &&
	test_must_fail git branch --alias bre
'

test_expect_success 'git branch --alias refuses to overwrite existing symref' '
	git branch --alias syme &&
	test_must_fail git branch --alias syme
'

test_expect_success 'git branch -d refuses to delete a checked out symref' '
	git branch --alias symd &&
	git checkout symd &&
	test_must_fail git branch -d symd
'

test_expect_success 'git branch -d refuses to delete an indirectly checked out symref' '
	git symbolic-ref refs/heads/symd2 refs/heads/symd &&
	git checkout symd2 &&
	test_must_fail git branch -d symd2 &&
	test_must_fail git branch -d symd
'

test_expect_success 'git branch -d refuses to create a dangling symref' '
	git branch dangling_parent &&
	git branch --alias dangling dangling_parent &&
	git branch -d dangling_parent &&
	test_path_is_file .git/refs/heads/dangling_parent
'

test_expect_success 'git branch -D forces creation of dangling symref' '
	git branch -D dangling_parent &&
	test_must_fail test_path_is_file .git/refs/heads/dangling_parent
'

test_done
