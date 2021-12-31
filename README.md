BAKU: Build A Kind Unit

ACTUALLY THIS CODE IS CURRENTLY BROKEN! SORRY! UNDER CONSTRUCTION!!!
FUNNY STORY BUT I'M SUPER NEW AND CAN'T GET THE JCLs TO WORK
ALSO I'M LOSING MAINFRAME ACCESS SO IT'S LOOKIN' ROUGH HERE FOR A SEC
IT WAS CALLED MASTER THE MAINFRAME BUT I'VE GOT A COUPLE DECADES TO GO

Historically, Baku are Japanese supernatural beings that are said to devour 
nightmares.

This unit of software, BAKU, will also devour nightmares for new mainframers
experiencing night terrors from the horrors of mangled JCL files. With these
templates they will slay their fears instead of slipping into an
incomprehensible, bottomless void falling forever or until a senior 
mainframe reaches down from the lands beyond mere mortals to rescue them!!

I wrote a song for BAKU. You'll have to imagine music for this or else it
will just seem like an especially annoying verse of poetry:

BAKU BAKU BAKU!
BUILD A KIND UNIT
BUILD A KIND UNIT
IT'S BAKU!!!!
THE ANSWER TO YOUR PRAYERS
IIIIIT'S BAKU!!!!
NO MORE JCL NIGHTMARES
IIIIIIIIIT'S BAKUUUUUUUUU

Prerequisites: You must have a zosmf profile already created and Zowe CLI
installed on your *nix machine. I've heard Windows has Linux builtin these
days so maybe that too. Also your remote z/OS mainframe probably has to be
setup exactly like the 2020 Master the Mainframe was setup?? Here's the
thing: It works on my machine at the exact moment that I'm writing this
and I don't even know enough to realize how deeply ignorant I am of basic
core z/OS fundamentals. There's probably a dozen better ways to do this.
Probably with Ansible?? If I could build a time machine, work in the
industry for a couple decades, and then return to this present moment BAKU
would be much more useful and well crafted. Maybe something like BAKU
already exists and I just didn't know the magic keystroke to bring up a
secret menu.

Hopefully, someone will realize how brilliant the core idea of BAKU is and
create something better that's loaded on every z/OS machine to help onboard 
new mainframers and allay their fears of the strnge JCL cards that aren't
even physical cards.

How to use BAKU:

At the command line in the BAKU directory:

    $ chmod +x BAKU.sh
    $ ./BAKU.sh

It will request your mainframe userid and then create a partitioned dataset
containing some examples of REXX, COBOL, and JCL  members for you to use as
examples/templates. It was cobbled together from various sources by an
amateur so please keep you expectations low. TIA!

If it doesn't work then I don't know what the problem is. Something to do
with your computer probably since it worked on mine. Maybe ask a senior
mainframer?? While you've got their ear see if they can rewrite this in 
Ansible or a USS file or with a bit-flipping cosmic ray or a butterfly
flapping its wings resulting in a hurricane that has 40-60 years of z/OS
Assembler language experince and excellent keyboard skills. I haven't slept
in days and I'm starting to ramble and so I bid you a hearty:

BAKU BAKU BAKU!
GOOD LUCK!!!

P.S. Baku is also the capital of Azerbaijan which is the largest city below
sea level in in the world. Did you know that? I sure as heck didn't until
today! Thanks Wikipedia!

Hot Tip!
The format for deleting a dataset is:

    $ zowe zos-files delete ds [dataset name] -f

Don't forget the -f flag. It stands for 'force' and the computer won't
believe that you really actually truly want to delete a dataset 
until you use it.

Another Hot Tip!
The format for executing a program is:

    $ zowe tso issue command "exec '[dataset]([member to execute])'" --ssm
