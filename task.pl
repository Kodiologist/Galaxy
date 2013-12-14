#!/usr/bin/perl -T

my %p;
%p = @ARGV; s/,\z// foreach values %p; # DEPLOYMENT SCRIPT EDITS THIS LINE

use strict;

use Tversky qw(htmlsafe cat FREE_RESPONSE);

# ------------------------------------------------
# * Declarations
# ------------------------------------------------

my $o; # Will be our Tversky object.

sub p ($)
   {"<p>$_[0]</p>"}

use constant TEXTAREA_MAX_CHARS =>
    1_000 * 6;   # About 1,000 words.

use constant FREQS =>
   ('?' => 'Unknown',
    0 => 'Never',
    1 => 'Rarely',
    2 => 'Sometimes',
    3 => 'Usually',
    4 => 'Always');

use constant GENDERS =>
   (['Male', 'Male'] => '',
    ['Female', 'Female'] => '',
    ['MtF', 'Transgender (male-to-female)'] => '',
    ['FtM', 'Transgender (female-to-male)'] => '',
    'Other' => FREE_RESPONSE);

# ------------------------------------------------
# * Tasks
# ------------------------------------------------

# ** Demographics

sub demographics ()
   {$o->multiple_choice_page('gender',
        p 'What is your gender?',
        GENDERS);

    $o->nonneg_int_entry_page('age',
        p 'How old are you?');

    $o->checkboxes_page('race',
        p 'What is your race or ethnicity?',
        AT_LEAST => 1,
        asian => 'Asian, Pacific Islander, or Native Hawaiian',
        black => 'Black',
        hisp => 'Hispanic or Latino',
        natam => 'Native American, American Indian, or Alaska Native',
        white => 'White');

    $o->multiple_choice_page('education',
        p 'What is the highest level of education you have achieved?',
        ['Low', 'A'] => 'Did not complete high school',
        ['HighSchool', 'B'] => 'High-school graduate',
        ['College', 'C'] => 'Some college',
        ['Ugrad', 'D'] => q{Undergraduate degree (e.g., associate or bachelor's)},
        ['Grad', 'E'] => q{Graduate degree (e.g., master's or doctorate)});
     
    $o->multiple_choice_page('income',
        p 'What is your personal income per year (earned or from government benefits)?',
        0 => 'Nothing',
        1 => '$1 to $4,999',
        5 => '$5,000 to $9,999',
        10 => '$10,000 to $19,999',
        20 => '$20,000 to $29,999',
        30 => '$30,000 to $39,999',
        40 => '$40,000 to $59,999',
        60 => '$60,000 to $79,999',
        80 => '$80,000 to $99,999',
        100 => '$100,000 to $149,999',
        150 => '$150,000 or more');

    $o->yesno_page('ever_employed',
        p 'Have you ever been employed?');}

# ** Sexual preferences

sub rate_preference
   {my ($key, $text) = @_;
    $o->discrete_rating_page($key,
        cat
           (p 'How sexually appealing is…?',
            p htmlsafe $text),
        scale_points => 7,
        anchors => ['Not at all appealing', 'Somewhat appealing', 'Very appealing']);}

my %pref_items = do
   {my $text = q{
        mast_solo_m	[M] Masturbating alone (touching your penis; jacking off)
        mast_solo_f	[F] Masturbating alone (touching your clitoris or vagina)
        coitus_m	[M] Having vaginal sex with a woman (penetrating a woman with your penis)
        coitus_f	[F] Having vaginal sex with a man (being penetrated by a man's penis)
        analpen_to_f	[M] Giving anal sex to a woman (penetrating a woman's anus with your penis; topping)
        analpen_to_m	[M] Giving anal sex to a man (penetrating a man's anus with your penis; topping)
        analpen_rec	Receiving anal sex (being anally penetrated by a man's penis; bottoming)
        fellatio_rec	[M] Receiving oral sex (fellatio; getting a blowjob)
        fellatio_to	Giving a man oral sex (fellatio; giving a blowjob)
        cunn_rec	[F] Receiving oral sex (cunnilingus; being eaten out)
        cunn_to		Giving a woman oral sex (cunnilingus; eating her out)
        anil_to_f	Giving a woman a rimjob (anilingus; licking a woman's anus)
        anil_to_m	Giving a man a rimjob (anilingus; licking a man's anus)
        anil_rec	Receiving a rimjob (anilingus; having your anus licked)
        mast_rec_m	[M] Receiving masturbation from a partner (getting a handjob; being jacked off)
        mast_to_m	Masturbating a man (giving a handjob; jacking him off)
        mast_rec_f	[F] Receiving masturbation from a partner (having your clitoris or vagina touched by your partner's hands)
        mast_to_f	Masturbating a woman (touching a woman's clitoris or vagina with your hands)
        objpen_rec	Being penetrated by an object, such as a dildo
        objpen_to	Penetrating your partner with an object, such as a dildo
        hug		Hugging
        kiss		Kissing
        intimacy	Feeling emotionally close to your sex partner
        love		Feeling in love with your partner
        control_to	Totally controlling your sex partner 
        control_rec	Being totally controlled by your sex partner 
        desired		Being sexually desired by your partner
        pleasure_to	Giving your partner sexual pleasure
        pain_to		Causing pain to your sex partner
        pain_rec	Having your sex partner cause you pain
        bondage_to	Tying up your sex partner as part of sex (bondage)
        bondage_rec	Being tied up by your sex partner as part of sex (bondage)
        urine_to	Urinating on your sex partner as part of sex (watersports)
        urine_rec	Being urinated on by your sex partner as part of sex (watersports)
        leather		Using leather as part of sex
        insult_to	Calling your sex partner insulting names during sex (e.g., "slut")
        insult_rec	Being called insulting names during sex (e.g., "slut")
        semen_to_mouth	[M] Ejaculating (cumming) in your sex partner's mouth without a condom
        semen_to_vag	[M] Ejaculating (cumming) in your sex partner's vagina without a condom
        semen_to_anus	[M] Ejaculating (cumming) in your sex partner's anus without a condom
        semen_rec_mouth	Receiving a man's semen/cum in your mouth without a condom
        semen_rec_vag	[F] Receiving a man's semen/cum in your vagina without a condom
        semen_rec_anus	Receiving a man's semen/cum in your anus without a condom
        semen_swallow	Swallowing a man's semen/cum
        group_sex	Having sex with two or more people at once
        rape_to		Raping someone
        rape_rec	Being raped
        porn_written	Reading pornographic or erotic stories
        porn_visual	Viewing pornographic or erotic videos or pictures
        porn_video_mf	Watching a video of a man and woman having sex
        porn_video_ff	Watching a video of two women having sex
        porn_video_mm	Watching a video of two men having sex
        voyeur_known	Watching other people naked, masturbating, or having sex, when they know that you're watching
        voyeur_secret	Watching other people naked, masturbating, or having sex, when they don't know that you're watching
        incest		Sex with someone you're related to (a family member)
        in_rship	Sex with someone you're in a relationship with
        friend		Sex with a friend you aren't in a relationship with
        recent_acq	Sex with someone you met a few hours ago
        stranger	Anonymous sex with a total stranger
        uncon		Sex with someone while they're unconscious (e.g., asleep or passed out from alcohol or a drug)
        penis_big	Sex with a man with a particularly large penis
        penis_small	Sex with a man with a particularly small penis
        breasts_big	Sex with a woman with particularly large breasts
        breasts_small	Sex with a woman with particularly small breasts
        butt_big	Sex with someone with particularly large buttocks
        butt_small	Sex with someone with particularly small buttocks
        feet_big	Sex with someone with particularly large feet
        feet_small	Sex with someone with particularly small feet
        feet		Sex inolving your or your partner's feet
        man		Sex with a man
        man_fem		Sex with a very feminine man
        man_mas		Sex with a very masculine man
        man_trans	Sex with a trans-man (i.e., someone assigned female sex by a doctor at birth, but who now identifies as male)
        woman		Sex with a woman
        woman_fem	Sex with a very feminine woman
        woman_mas	Sex with a very masculine woman
        woman_trans	Sex with a trans-woman (i.e., someone assigned male sex by a doctor at birth, but who now identifies as female)
        age_08		Sex with an 8-year-old
        age_14		Sex with a 14-year-old
        age_70		Sex with a 70-year-old
        rich		Sex with a wealthy person with a prestigious profession
        rebel		Sex with a rebel or rule-breaker (bad boy, bad girl)
        experienced	Sex with a person with lots of previous sexual experience
        virgin		Sex with a virgin
        persity_eh	Sex with an extraverted, enthusiastic person
        persity_al	Sex with a critical, quarrelsome person
        persity_ch	Sex with a dependable, self-disciplined person
        persity_nh	Sex with an anxious, easily upset person
        persity_oh	Sex with a person who is complex and open to new experiences
        persity_el	Sex with a reserved, quiet person
        persity_ah	Sex with a sympathetic, warm person
        persity_cl	Sex with a disorganized, careless person
        persity_nl	Sex with a calm, emotionally stable person
        persity_ol	Sex with a conventional, uncreative person};
    my %items;
    $items{$1} = {text => $3, gender => ($2 && ($2 eq '[M]' ? 'Male' : 'Female'))}
        while $text =~ /^\s+(\S+)\s+(\[[MF]\])?(.+)/mg;
    %items};

sub preferences ()
   {my $male = $o->getu('gender') eq 'Male';
    my $female = $o->getu('gender') eq 'Female';

    $o->okay_page('preferences_instructions', cat

        q{<p class="long">On the following pages, you will see descriptions of various activities. We would like you to consider how sexually appealing you find each of these activities. Importantly, we are not asking you whether you would really do these things, or if you've already done them. Try to put aside concerns such as safety, religion, politics, morality, and society's expectations. Answer using only your sexual and romantic feelings.</p>},

        q{<p class="long">We use the word "sex" to mean any kind of sexual contact (not just sexual intercourse, but also, for example, oral sex). We use the phrase "your sex partner" to mean someone you might have sex with.</p>});

    $o->assign_permutation('preferences_permutation',
        ',', keys %pref_items);
    foreach (split qr/,/, $o->getu('preferences_permutation'))
       {my %item = %{$pref_items{$_}};
        if ($item{gender} and $item{gender} eq 'Male')
           {$male or next;}
        if ($item{gender} and $item{gender} eq 'Female')
           {$female or next;}
        rate_preference "p.$_", $item{text};}

    $o->text_entry_page('preferences_other',
        q{<p class="long"><strong>Optional:</strong> Is there anything you find particularly sexually appealing that we didn't ask about? Or is there anything else you'd like to add to the responses you've provided?</p>},
        multiline => 1,
        accept_blank => 1,
        max_chars => TEXTAREA_MAX_CHARS);}

# ** Drug use

sub drug_use ()
   {$o->multiple_choice_page('alcohol_freq',
        p 'How often do you drink alcohol shortly before having sex?',
        FREQS);
     if ($o->getu('alcohol_freq') ne '0')
        {$o->multiple_choice_page('alcohol_amount',
            p 'When you do drink before sex, how much do you typically drink?',
            0 => 'Not enough to feel an effect',
            1 => 'Enough to feel a slight buzz or be a little tipsy',
            2 => 'Enough to feel a significant buzz or be somewhat tipsy',
            3 => 'Enough to get drunk',
            4 => 'Enough to pass out or black out');
        $o->checkboxes_page('alcohol_reasons',
            p 'When you do drink before sex, what are the primary reasons?',
            AT_LEAST => 1,
            relax => 'To loosen up and relax',
            improve_performance => 'To improve sexual performance',
            performance_anxiety => 'To reduce performance anxiety',
            enhance_overall => 'To enhance the sexual experience overall',
            enhance_partner => 'To make my sex partner more appealing',
            convince_partner => 'To get my sex partner to drink',
            other => ['Other', FREE_RESPONSE]);}

    $o->multiple_choice_page('drugs_freq',
        p 'How often do you use drugs (not including caffeine, alcohol, or a medication prescribed to you, but including cannabis, cocaine, methamphetamine, poppers, etc.) shortly before or during sex?',
        FREQS);
     if ($o->getu('drugs_freq') ne '0')
        {$o->checkboxes_page('drugs_which',
            p 'Which drugs?',
            AT_LEAST => 1,
            cannabis => 'Cannabis',
            meth => 'Methamphetamine',
            mdma => 'MDMA (ecstasy, molly)',
            cocaine => 'Cocaine',
            poppers => 'Poppers',
            heroin => 'Heroin',
            rx => 'Prescription medication not prescribed to you, or in a greater amount than prescribed',
            other => ['Other', FREE_RESPONSE]);
        $o->getu('drugs_which.rx') and
            $o->text_entry_page('drugs_rx',
                p 'Which prescription medications?');
        $o->multiple_choice_page('drugs_amount',
            p 'When you use drugs before or during sex, how much do you typically use?',
            0 => 'Not enough to feel an effect',
            1 => 'Enough to feel a slight effect',
            2 => 'Enough to feel a significant effect',
            3 => 'Enough to feel a strong effect',
            4 => 'Enough to pass out or go out of control');
        $o->checkboxes_page('drugs_reasons',
            p 'When you use drugs before or during sex, what are the primary reasons?',
            AT_LEAST => 1,
            relax => 'To loosen up and relax',
            improve_performance => 'To improve sexual performance',
            performance_anxiety => 'To reduce performance anxiety',
            enhance_overall => 'To enhance the sexual experience overall',
            enhance_partner => 'To make my sex partner more appealing',
            convince_partner => 'To get my sex partner to use a drug',
            other => ['Other', FREE_RESPONSE]);}}

# ** Safe sex

sub safe_sex ()
   {my $male = $o->getu('gender') eq 'Male';
    my $female = $o->getu('gender') eq 'Female';
    sub condom_page
       {$o->multiple_choice_page($_[0],
            $_[1],
            'N/A' => 'I never have this kind of sex',
            FREQS);}

    if ($male)
       {sub condom_while
            {p "How often do you wear a condom while $_[0]?"}
        condom_page 'condom_fellatio_rec',
            condom_while 'receiving oral sex (a blowjob; fellatio)';
        condom_page 'condom_coitus_m',
            condom_while 'having vaginal sex';
        condom_page 'condom_analpen_to_m',
            condom_while q{giving anal sex to a man (penetrating a man's anus with your penis; topping)};
        condom_page 'condom_analpen_to_f',
            condom_while q{giving anal sex to a woman (penetrating a woman's anus with your penis)};}

    if ($female)
       {condom_page 'condom_coitus_f',
            p q{How often do your male sex partners wear a condom while you have vaginal sex?};
        $o->multiple_choice_page('contraceptive_pills',
            p q{If you take birth-control pills to prevent pregnancy, how regularly do you take your pills as prescribed?},
            'N/A' => q{I don't take birth-control pills to prevent pregnancy},
            FREQS);}

    condom_page 'condom_fellatio_to',
        p q{How often do your male sex partners wear a condom while you give them oral sex (fellatio; a blowjob)?};
    condom_page 'condom_analpen_rec',
        p q{How often do your male sex partners wear a condom while you are receiving anal sex (being anally penetrated by a man's penis; "bottoming")?};

    $o->checkboxes_page('partner_search',
        p 'Where do you actively look for sex partners? (Check all that apply.)',
        nightlife => 'Clubs or bars',
        public => 'Public places (e.g., shops, subway)',
        work => 'Your school or workplace',
        web => 'Websites',
        smartphone => 'Smartphone apps (e.g., Grindr)');}

# ** Externalizing

sub externalizing ()
   {my %items =
    # From: Patrick, C. J., Kramer, M. D., Krueger, R. F., & Markon, K. E. (in press). Optimizing efficiency of psychopathology assessment through quantitative modeling: Development of a brief form of the externalizing spectrum inventory. Psychological Assessment.
       ('001' => q{I have had problems at work because I was irresponsible.},
        '009' => q{I have stolen something out of a vehicle.},
        '010' => q{I get in trouble for not considering the consequences of my actions.},
        '019' => q{I have missed work without bothering to call in.},
        '028' => q{I have taken money from someone's purse or wallet without asking.},
        '036' => q{Others have told me they are concerned about my lack of self-control. },
        '041' => q{I often get bored quickly and lose interest.},
        '044' => q{I have taken items from a store without paying for them.},
        '049' => q{I've gotten in trouble because I missed too much school.},
        '065' => q{People often abuse my trust.},
        '073' => q{I have lost a friend because of irresponsible things I've done.},
        '084' => q{I have robbed someone.},
        '090' => q{I have good control over myself.},
        '092' => q{I have a hard time waiting patiently for things I want.},
        '095' => q{My impulsive decisions have caused problems with loved ones.},
        '112' => q{I jump into things without thinking.},
        '125' => q{I keep appointments I make.},
        '143' => q{I've often missed things I promised to attend.},
        '144' => q{I have conned people to get money from them.},
        '152' => q{I often act on immediate needs.});

    foreach (keys %items)
       {$o->multiple_choice_page("xtizing.$_",
            cat
              (p 'For each statement, select the answer that describes you best.',
               p $items{$_}),
            1 => 'False',
            2 => 'Somewhat false',
            3 => 'Somewhat true',
            4 => 'True');}}

# ** Sexual orientation and sexual experience

sub orientation_and_experience ()
   {$o->multiple_choice_page('rship',
       p 'What is your current relationship status?',
       0 => 'Single',
       1 => 'Dating',
       2 => 'Engaged',
       3 => 'Married, domestically partnered, or in a civil union');
    $o->getu('rship') ne '0' and
        $o->multiple_choice_page('partner_gender',
            p 'What gender is your romantic partner?',
            GENDERS);

    $o->multiple_choice_page('orient',
        p 'What is your sexual orientation?',
        ['Het', 'A'] => 'Heterosexual or straight',
        ['Gay', 'B'] => 'Gay or lesbian',
        ['Bi', 'C'] => 'Bisexual',
        ['Ace', 'D'] => 'Asexual',
        ['?', 'E'] => 'Not sure',
        'Other' => FREE_RESPONSE);

    $o->multiple_choice_page('attract_to_f',
        p 'Which of the following best describes your feelings of sexual attraction to women?',
        '?' => 'Not sure',
        0 => 'Not at all sexually attracted',
        1 => 'A little sexually attracted',
        2 => 'Somewhat sexually attracted',
        3 => 'A good deal sexually attracted',
        4 => 'Very sexually attracted');
    $o->multiple_choice_page('attract_to_m',
        p 'Which of the following best describes your feelings of sexual attraction to men?',
        '?' => 'Not sure',
        0 => 'Not at all sexually attracted',
        1 => 'A little sexually attracted',
        2 => 'Somewhat sexually attracted',
        3 => 'A good deal sexually attracted',
        4 => 'Very sexually attracted');

    sub sex_amount
       {$o->nonneg_int_entry_page("sex_amount.$_[0]",
            p "In $_[1], how many $_[2] have you had sex with? (If you don't know the exact number, estimate.)");}
    sex_amount 'year_f', 'the past 12 months', 'women';
    sex_amount 'year_m', 'the past 12 months', 'men';
    sex_amount 'year_mtf', 'the past 12 months', 'trans-women';
    sex_amount 'year_ftm', 'the past 12 months', 'trans-men';
    sex_amount 'total_f', 'total', 'women';
    sex_amount 'total_m', 'total', 'men';
    sex_amount 'total_mtf', 'total', 'trans-women';
    sex_amount 'total_ftm', 'total', 'trans-men';}

# ** Finally

sub finally ()
   {# Some repeats from the preferences items.
    rate_preference 'p.fellatio_to.2', $pref_items{fellatio_to}{text};
    rate_preference 'p.friend.2', $pref_items{friend}{text};

    $o->discrete_rating_page('honest',
        p q{How honest were you able to be while answering this survey? (We won't withhold payment based on your answer to this question.)},
        scale_points => 5,
        anchors => ['Not at all honest', 'Somewhat honest', 'Entirely honest']);

    $o->text_entry_page('comments',
        p q{<strong>Optional:</strong> Comments on this study.},
        multiline => 1,
        accept_blank => 1,
        max_chars => TEXTAREA_MAX_CHARS);}

# ------------------------------------------------
# * Mainline code
# ------------------------------------------------

$o = new Tversky
   (cookie_name_suffix => 'Galaxy',
    here_url => $p{here_url},
    database_path => $p{database_path},
    consent_path => $p{consent_path},
    task => $p{task},

    #preview => sub
    #   {decision undef, 20, 'today', 60, 'in 1 month';},

    #after_consent_prep => sub
    #   {my $o = shift;
    #    $o->assign_permutation('task_order_1', ',', keys %tasks);
    #    $o->assign_permutation('task_order_2', ',', keys %tasks);},

    head => do {local $/; <DATA>},
    footer => "\n\n\n</body></html>\n",

    mturk => $p{mturk},
    assume_consent => $p{assume_consent},
    password_hash => $p{password_hash},
    password_salt => $p{password_salt});

$o->run(sub
   {demographics;
    preferences;
    drug_use;
    safe_sex;
    externalizing;
    orientation_and_experience;
    finally;});

# ------------------------------------------------
# * HTML header
# ------------------------------------------------

__DATA__

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>[Some Title]</title>

<style type="text/css">

    h1, form, div.expbody p
       {text-align: center;}

    div.expbody p.long
       {text-align: left;}

    input.consent_statement
       {border: thin solid black;
        background-color: white;
        color: black;
        margin-bottom: .5em;}

    div.multiple_choice_box, div.checkboxes_box
       {display: table;
        margin-left: auto; margin-right: auto;}
    div.multiple_choice_box > div.row,  div.checkboxes_box > div.row
       {display: table-row;}
    div.multiple_choice_box > div.row > div
       {display: table-cell;}
    div.multiple_choice_box > div.row > div.button, div.checkboxes_box > div.row
       {padding-right: 1em;
        vertical-align: middle;
        text-align: left;}
    div.multiple_choice_box > div.row > div.body
       {text-align: left;
        vertical-align: middle;}
    div.checkboxes_box input[type = checkbox]
       {margin-right: .5em;}
    div.checkboxes_box input[type = text]
       {margin-left: .5em;}

    button.discrete_scale_button
       {margin-left: .25em;
        width: 2em;
        height: 2em;
        margin-right: .25em;}

    input.text_entry, textarea.text_entry
       {border: thin solid black;
        background-color: white;
        color: black;}

    textarea.text_entry
       {width: 90%;}

</style>
