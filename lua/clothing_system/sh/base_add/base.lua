list.Set( "player_base_clothing_system", "pony", {
    NiceModel = {
        'models/ppm/player_default_base_new.mdl',
        'models/ppm/player_default_base_new_nj.mdl',
        'models/ppm/player_default_base_nj.mdl',
        'models/ppm/player_default_base.mdl',
        'models/cppm/player_default_base.mdl',
        'models/cppm/player_default_base_nj.mdl',
    },
    BoneType = {
        Head = false, -- Голова
        Neck = false, -- Шея

        Chest = false, -- Грудь
        BodyCenter = false, -- Тело
        Pelvis = false, -- Круп
        Spine = false, -- Спина

        RightSide = false, -- Правый бок
        LeftSide = false, -- Левый бок

        FrontLeftHoof = false, -- Переднее левое копыто
        FontRightHoof = false, -- Переднее заднее копыто
        RearLeftHoof = false, -- Заднее левое копыто
        RearRightHoof = false, -- Заднее правое копыто

        TipFrontLeftHoof = false, -- Переднее левое копыто после колена
        TipFrontRightHoof = false, -- Переднее правое копыто после колена
        TipRearLeftHoof = false, -- Заднее левое копыто после колена
        TipRearRightHoof = false, -- Заднее правое копыто после колена
    }
} )

list.Set( "player_base_clothing_system", "hl2_player", {
    BoneType = {
        Head = false, -- Голова
        Neck = false, -- Шея

        Chest = false, -- Грудь
        BodyCenter = false, -- Тело
        Stomach = false, -- Живот
        Thigh = false, -- Бёдра
        Pelvis = false, -- Таз
        Spine = false, -- Спина

        LeftLeg = false, -- Левая нога до колена
        LeftKnee = false, -- Левое колено
        LeftShin = false, -- Левая голень
        LeftFoot = false, -- Левая нога
        LeftHeel = false, -- Левая пятка

        RightLeg = false, -- Правая нога до колена
        RightKnee = false, -- Правое колено
        RightShin = false, -- Правая голень
        RightFoot = false, -- Правая нога
        RightHeel = false, -- Правая пятка

        LeftShoulder = false, -- Левое плечо
        LeftArm = false, -- Левая рука до локтя
        LeftElbow = false, -- Левый локоть
        LeftForearm = false, -- Левое предплечье
        LeftWrist = false, -- Левое запястье
        LeftHand = false, -- Левая кисть/ладонь

        RightShoulder = false, -- Правое плечо
        RightArm = false, -- Правая рука до локтя
        RightElbow = false, -- Правый локоть
        RightForearm = false, -- Правое предплечье
        RightWrist = false, -- Правое запястье
        RightHand = false, -- Правая кисть/ладонь
    }
} )