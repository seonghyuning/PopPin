package net.developia.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.developia.domain.LikeDTO;
import net.developia.domain.PopUpStoreVO;
import net.developia.mapper.LikeMapper;

@Service
public class LikeServiceImpl implements LikeService {

    @Autowired
    private LikeMapper likeMapper;

    @Override
    public boolean isLiked(LikeDTO like) {
        System.out.println("Checking like for: " + like);
        return likeMapper.isLiked(like) > 0;
    }

    @Override
    public void toggleLike(LikeDTO like) {
        System.out.println("Toggling like for: " + like);
        if (isLiked(like)) {
            System.out.println("Deleting like for: " + like);
            likeMapper.deleteLike(like);
        } else {
            System.out.println("Inserting like for: " + like);
            likeMapper.insertLike(like);
        }
    }



    @Override
    public List<PopUpStoreVO> getLikedStores(String username) {
        return likeMapper.selectLikedStores(username);
    }
}
