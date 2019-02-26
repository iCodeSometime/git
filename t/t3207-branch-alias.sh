#!/bin/sh
#
# Copyright (c) 2005 Amos Waterland
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

test_done
