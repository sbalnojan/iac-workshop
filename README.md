# Infrastructure as Code (IaC) Workshop

In this "workshop", I introduce a bunch of tools

- the AWS CLI
- Terraform

(Pulumi & AWS CDK possibly to come later...)

And a list of concepts & principles including:

- Task Group 1: Reproducibility (& making scripts reproducible)
- Task Group 2: TDD for IaC, Declarative Code, IaC State, Terraforms Rule No. 1 (& mocking, local unit testing IaC)
- Task Group 3: Intro TF.
- Task Group 4: Disposability, Continual Availability. (& Modular programming is great!)

How I like to "teach tech":

1.  Learning the macro from the micro. (That means, we start as small as possible and learn principles which then can be transferred to everything else. It also means the exercises sometimes use a "wrong" tool to teach you something, a tool/solution you shouldn't use like that in production.)

2.  Test-driven to the core (Thanks Uwe Schäfer for helping me internalize that!)

3.  ./go is the way to go.

Dependencies: You should have installed...

- the aws CLI
- terraform
- ...

## WIP

Three aspects aren't finished yet... 1. I haven't gotten around to finish the TDD part yet. 2nd. the intro to Pulumi & AWS CDK is still missing (and thus higher level constructs as well as the benefits of first grade programming languages in IaC.).
3rd. Batect is here to help you get started quickly, but again I haven't implemented all aspects yet.

## Task Group 1

Tool: AWS CLI

Exercise 1: Create a S3 bucket, non-public access, with your name.

Exercise 2: Ok great, now take a look at what you did. Do you think
someone else could reproduce that? Make it reproducible with the minimal
amount of effort.

Exercise 3: Nice, now take a final look at what you created and see whether
it adhere's to good practices. Does someone else has to edit it to run it
as well with e.g. a different name? Adjust that.

Principle: Reproducibility. (Making scripts reproducible & reuseable,
parametrizing,...)

Side Note: For bash I recommend ShellCheck & the Google & Gruntworks
styleguide (https://github.com/gruntwork-io/bash-commons)

(Solutions are at /solutions)

## Task Group 2

Now we've hacked a bit. Let's turn to a more serious workflow: A test-driven
workflow.

### Running local AWS tests

I also like to have a local dev environment, so I put one into this repository.
I can recommend both localstack and moto (the server version). We're going
to use moto here. You could use moto always from the docker image like this:

```
$ docker pull motoserver/moto
...
$ docker run -p 0.0.0.0:5000:5000 motoserver/moto
...# OR
$ ./batect run_mock
...
```

To test AWS resources locally you got to redirect the "endpoint". This can be
done like this:

```
aws s3 ls --endpoint-url http://127.0.0.1:5000/
...
aws s3api create-bucket --bucket test-bucket --endpoint-url http://127.0.0.1:5000/
aws s3 ls --endpoint-url http://127.0.0.1:5000/
..
2021-02-08 19:46:47 test-bucket
```

Fine, you just got a local AWS copy to work!

### Bash tests

You could simply create any random test script, but I like to use BATS to
test bash code. Since bash has no proper package manager, you can install it via
gitsubmodules.

Run a demo test:

```
./exercises/libs/bats/bin/bats exercises/demo_test.bats
```

### Exercise 2 Let's write a test for what we just done

Let's check if our create bucket script really works...

```
./../my_solutions/exercise_2 my-bucket test

aws_cli_output=$(aws s3api get-bucket-location --bucket my-bucket --endpoint-url http://127.0.0.1:5000/)

echo "Output is...$aws_cli_output"

  assert_equals aws_cli_output 1
```

Perfect, that works.

Question: Now run the test a second time... What happens?

(Uh oh, new concept: Declarative vs. Imperative code...)

Question 2: What if we were to randomize the name?

Both problems could be handled with by:

1.  Doing a "if is already there, do nothing otherwise create it" logic (a deployment mechanism)
2.  Saving the name of the bucket to file (bucket.state)
3.  Combining both things...

And that is, what we have the concepts: Declarative Code & State of our
infrastructure for. It also displays the rule no. 1 of terraform.

### Task Group 3

We do a little piece together, doing what we just solved
in terraform as well...

```
$ exercises/libs/bats/bin/bats exercises/exercise_3.bats

... ERROR
```

Now let's fix that... step one is to "initialize TF with the correct provider".
For us that means AWS, the correct region & adding the test endpoint for
awesomeness.

Run

```
terraform plan
```

to see a glimpse of what terraform looks like.

Now run terraform apply, and then run it twice!

Perfect, we just improved quite a bit just by changing over to terraform.

Now let's fix our test...

Solution at: solutions/exercise_3

### Task Group 4

Let's now take care of one important principle, "disposability".

(For that we got to switch away from local testing though for now..)

```
$ exercises/libs/bats/bin/bats exercises/exercise_4_1.bats

"Create a EC2 Instance with an apache webserver"
... ERROR
```

Task 4.2: Now let's make this "disposable". Terminate the instance. Does it restart?
Nope... so let's take care of that (hint: you'll need an ASG...MAYBE you can
find a module...)

#### ...(incomplete)

Questions: Is this now really "disposable"? What's missing
and how would you solve it?

Questions: Now turn to another tightly coupled principle. Is this continually available?
If not, how would you solve it? ()

### Task Group 5

AWS CDK = Python (or other) high level code that compiles to Cloudformation
(long bulky JSON), and thus is able to use Stacks as cool deployment &
infrastructure mgmt mechanism.
Pulumi = AWS CDK + Terraform - Stacks.

With that in mind, let us finally take a look at the AWS CDK.

## Ressources

All the BATS magic is taken from https://medium.com/@pimterry/testing-your-shell-scripts-with-bats-abfca9bdc5b9.
